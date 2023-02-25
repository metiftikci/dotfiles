local opts = { noremap = true, silent = true }

vim.api.nvim_set_keymap('n', '<leader>hh', '<cmd>noh<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>x', '<cmd>Ex<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>[c', '<cmd>Gitsigns prev_hunk<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>]c', '<cmd>Gitsigns next_hunk<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>hi', '<cmd>Gitsigns preview_hunk_inline<CR>', opts)
