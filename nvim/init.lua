require("plugins")

-- Load the test runner module
local xunit_runner = require("xunit_runner")

-- 1. Create a Custom User Command
-- This allows you to run the tests using :RunXUnitClass from the command line.
vim.api.nvim_create_user_command(
    'RunXUnitClass', -- The name of the command (e.g., :RunXUnitClass)
    xunit_runner.run_dotnet_test,
    {
        desc = "Run current C# XUnit Test Class (Fully Qualified Name)",
        -- Add 'buffer' if you only want the command available in the current buffer type,
        -- but typically commands are global.
    }
)
