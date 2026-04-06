require("telescope").setup({
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown({}),
    },
    live_grep_args = {
      auto_quoting = true,
    },
  },
  defaults = {
    preview = false,
    borderchars = { "┈", "┊", "┈", "┊", "┌", "┐", "┘", "└" },
    prompt_prefix = "  ",
    selection_caret = "» ",
  },
})

require('telescope').load_extension('live_grep_args')
require('telescope').load_extension('file_browser')
require('telescope').load_extension('ui-select')

local opts = { noremap = true, silent = true }

vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>Telescope find_files<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>fg', '<cmd>Telescope live_grep_args<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>fb', '<cmd>Telescope buffers<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>fx', '<cmd>Telescope file_browser<CR>', opts)

vim.api.nvim_set_keymap('v', '<leader>ff', '"hy\\ff<c-r>h', {})
vim.api.nvim_set_keymap('v', '<leader>fg', '"hy\\fg<c-r>h', {})
vim.api.nvim_set_keymap('v', '<leader>r', '"hy:%s/<c-r>h//g<left><left>', { noremap = true })
