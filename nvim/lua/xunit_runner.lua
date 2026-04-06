--[[
XUnit Dotnet Test Runner

This script defines a function to automatically determine the C# namespace and
class name from the current buffer, and execute `dotnet test` specifically
filtered for that class in a new Neovim terminal tab.

USAGE:
1. Save this file to lua/xunit_runner.lua in your config directory.
2. Call the function and map it in your init.lua (see instructions below).
--]]

local M = {}

-- Utility function to find the C# namespace and class name in the current buffer
M.get_test_info = function()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local namespace = nil
    local class_name = nil

    -- Regex patterns to find declarations. Assumes standard C# formatting.
    local ns_pattern = [[^%s*namespace%s+([%w%.]+)]]
    -- local class_pattern = [[^%s*(?:public)%s+(?:abstract%s+)?(?:static%s+)?class%s+([%w]+)]]
    local class_pattern = [[^%s*public%s+class%s+([%w_]+)]]

    for _, line in ipairs(lines) do
        -- Find Namespace
        local ns_match = string.match(line, ns_pattern)
        if ns_match then
            namespace = ns_match
        end

        -- Find Class Name
        local class_match = string.match(line, class_pattern)
        if class_match then
            class_name = class_match
            break -- Found the class, we can stop searching
        end
    end

    return namespace, class_name
end

-- Main function to run the test
M.run_dotnet_test = function()
    -- 1. Get the fully qualified name
    local namespace, class_name = M.get_test_info()

    if not namespace or not class_name then
        vim.notify("Could not find C# namespace or class name in the current file.", vim.log.levels.ERROR)
        return
    end

    local fully_qualified_name = namespace .. "." .. class_name

    -- 2. Construct the dotnet test command
    -- We use the `FullyQualifiedName` filter to target the specific class.
    local cmd = string.format("dotnet test --filter \"FullyQualifiedName~%s\"", fully_qualified_name)

    -- 3. Execute the command in a new tab using termopen
    local opts = {
        -- 'tab' opens the terminal in a new tab
        -- 'vsplit' or 'split' are also options if you prefer splits
        -- 'termopen' handles asynchronous execution automatically.
        term_opts = {
            vertical = false, -- We want a full tab
            noremap = true,
            -- Add an autocmd to close the tab when the test process exits
            on_exit = function(job_id, exit_code)
                -- Give the user a moment to see the output before closing
                vim.defer_fn(function()
                    local bufnr = vim.fn.bufname()
                    local winid = vim.fn.bufwinnr(bufnr)
                    if winid > 0 then
                        -- Close the terminal window/tab
                        vim.cmd("tabclose")
                    end
                end, 5000) -- Closes after 5 seconds
                vim.notify(
                    string.format("Tests finished for %s (Exit Code: %d)", class_name, exit_code),
                    exit_code == 0 and vim.log.levels.INFO or vim.log.levels.WARN
                )
            end,
        }
    }

    vim.cmd("tabnew")
    vim.fn.termopen(cmd)

    vim.notify(
        string.format("Running dotnet test for class: %s...", fully_qualified_name),
        vim.log.levels.INFO
    )
end

return M
