-- Copy file paths / line ranges / functions as references to paste into an AI
--   <leader>yl  (normal / visual) -> src/foo.lua:12  or  src/foo.lua:12-20
--   <leader>yc  (normal / visual) -> src/foo.lua:12-20 + selected code (```lua ... ```)
--   <leader>yf  (normal)          -> `Class.Method` in `src/foo.cs` (L42-60)

local M = {}

-- File path relative to the project root (cwd)
local function rel_path()
  local abs = vim.fn.expand("%:p")
  if abs == "" then
    return nil
  end
  return vim.fn.fnamemodify(abs, ":.")
end

local function to_clipboard(text)
  vim.fn.setreg("+", text) -- system clipboard
  vim.fn.setreg('"', text) -- unnamed register (so `p` works too)
  vim.notify("Kopyalandı: " .. text, vim.log.levels.INFO)
end

-- ─────────────────────────────────────────────────────────────
-- <leader>yl : file path + line(s)
-- ─────────────────────────────────────────────────────────────
function M.yank_lines()
  local path = rel_path()
  if not path then
    return vim.notify("Bu buffer bir dosyaya ait değil", vim.log.levels.WARN)
  end

  local s, e
  local mode = vim.fn.mode()
  if mode:match("[vV\22]") then -- v, V or Ctrl-V
    s, e = vim.fn.line("v"), vim.fn.line(".")
    if s > e then
      s, e = e, s
    end
    -- leave visual mode
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
  else
    s = vim.fn.line(".")
    e = s
  end

  local ref = (s == e) and ("%s:%d"):format(path, s) or ("%s:%d-%d"):format(path, s, e)
  to_clipboard(ref)
end

-- ─────────────────────────────────────────────────────────────
-- <leader>yc : selected code + file reference
-- ─────────────────────────────────────────────────────────────
function M.yank_code()
  local path = rel_path()
  if not path then
    return vim.notify("Bu buffer bir dosyaya ait değil", vim.log.levels.WARN)
  end

  local mode = vim.fn.mode()
  local lines, s, e

  if mode:match("[vV\22]") then
    local p1, p2 = vim.fn.getpos("v"), vim.fn.getpos(".")
    s, e = p1[2], p2[2]
    if s > e then
      s, e = e, s
    end
    if vim.fn.exists("*getregion") == 1 then
      -- Neovim 0.10+: exact selection (charwise / linewise / blockwise)
      lines = vim.fn.getregion(p1, p2, { type = mode })
    else
      -- older versions: full lines covered by the selection
      lines = vim.api.nvim_buf_get_lines(0, s - 1, e, false)
    end
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
  else
    -- normal mode: current line
    s = vim.fn.line(".")
    e = s
    lines = vim.api.nvim_buf_get_lines(0, s - 1, e, false)
  end

  local ref = (s == e) and ("%s:%d"):format(path, s) or ("%s:%d-%d"):format(path, s, e)
  local out
  if s == e then
    -- single line: plain text, leading/trailing whitespace trimmed
    out = ("%s: %s"):format(ref, vim.trim(table.concat(lines, " ")))
  else
    -- multiple lines: markdown code block
    out = ("%s\n```%s\n%s\n```"):format(ref, vim.bo.filetype, table.concat(lines, "\n"))
  end

  vim.fn.setreg("+", out)
  vim.fn.setreg('"', out)
  vim.notify(("Kopyalandı: %s (%d satır)"):format(ref, #lines), vim.log.levels.INFO)
end

-- ─────────────────────────────────────────────────────────────
-- <leader>yf : function / method name via treesitter + file
-- ─────────────────────────────────────────────────────────────
local function is_function_node(t)
  -- skip calls and type definitions
  if t:match("call") or t:match("invocation") or t:match("type") or t:match("parameter") then
    return false
  end
  return t:match("function") ~= nil
    or t:match("method") ~= nil
    or t:match("constructor") ~= nil
    or t:match("arrow") ~= nil
    or t:match("lambda") ~= nil
    or t == "func_literal"
end

local function is_class_node(t)
  if t:match("body") then
    return false
  end
  return t:match("class") ~= nil or t:match("struct") ~= nil or t:match("interface") ~= nil
end

local function text(node, bufnr)
  return vim.treesitter.get_node_text(node, bufnr)
end

-- Try to resolve the name of a function node
local function function_name(node, bufnr)
  -- 1) Most languages have a "name" field (C#, Java, Lua, Python, Go, Rust, JS...)
  local name = node:field("name")[1]
  if name then
    return text(name, bufnr)
  end

  -- 2) C / C++: declarator -> function_declarator -> declarator -> identifier
  local decl = node:field("declarator")[1]
  while decl do
    if decl:type():match("identifier") or decl:type():match("qualified") then
      return text(decl, bufnr)
    end
    decl = decl:field("declarator")[1] or decl:field("name")[1]
  end

  -- 3) Assignments like `const foo = () => {}` or `{ foo: function() {} }`
  local parent = node:parent()
  for _ = 1, 3 do
    if not parent then
      break
    end
    local n = parent:field("name")[1] or parent:field("key")[1] or parent:field("left")[1]
    if n then
      return text(n, bufnr)
    end
    -- Lua: local foo = function() ... end
    if parent:type() == "assignment_statement" then
      local vars = parent:child(0)
      if vars then
        return text(vars, bufnr)
      end
    end
    parent = parent:parent()
  end

  -- 4) Fallback: use the first line of the function
  local first = text(node, bufnr):match("^[^\n]*") or "anonim"
  return vim.trim(first)
end

function M.yank_function()
  local path = rel_path()
  if not path then
    return vim.notify("Bu buffer bir dosyaya ait değil", vim.log.levels.WARN)
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local ok, node = pcall(vim.treesitter.get_node, { bufnr = bufnr })
  if not ok or not node then
    return vim.notify("Treesitter parser bulunamadı", vim.log.levels.WARN)
  end

  -- walk up from the cursor to the nearest function
  local func = node
  while func and not is_function_node(func:type()) do
    func = func:parent()
  end
  if not func then
    return vim.notify("İmleç bir fonksiyon/metot içinde değil", vim.log.levels.WARN)
  end

  local name = function_name(func, bufnr)

  -- prepend enclosing class name(s): UserService.GetById
  local parts = { name }
  local p = func:parent()
  while p do
    if is_class_node(p:type()) then
      local cn = p:field("name")[1]
      if cn then
        table.insert(parts, 1, text(cn, bufnr))
      end
    end
    p = p:parent()
  end
  local full = table.concat(parts, ".")

  local sr, _, er, _ = func:range() -- 0-based
  local ref = ("`%s` in `%s` (L%d-%d)"):format(full, path, sr + 1, er + 1)
  to_clipboard(ref)
end

-- ─────────────────────────────────────────────────────────────
-- Keymaps
-- ─────────────────────────────────────────────────────────────
vim.keymap.set({ "n", "x" }, "<leader>yl", M.yank_lines, { desc = "AI: copy file path + line(s)" })
vim.keymap.set({ "n", "x" }, "<leader>yc", M.yank_code, { desc = "AI: copy selected code + file reference" })
vim.keymap.set("n", "<leader>yf", M.yank_function, { desc = "AI: copy function name + file" })

return M
