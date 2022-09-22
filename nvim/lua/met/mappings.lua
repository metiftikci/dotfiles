local opts = { noremap = true, silent = true }

vim.api.nvim_set_keymap('n', '<leader>hh', '<cmd>noh<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>x', '<cmd>Ex<CR>', opts)
