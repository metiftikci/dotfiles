local opts = { noremap = true, silent = true }

vim.api.nvim_set_keymap('n', '<leader>hh', '<cmd>noh<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>x', '<cmd>Ex<CR>', opts)

vim.api.nvim_set_keymap('n', '[c', '<cmd>Gitsigns prev_hunk<CR>', opts)
vim.api.nvim_set_keymap('n', ']c', '<cmd>Gitsigns next_hunk<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>hi', '<cmd>Gitsigns preview_hunk_inline<CR>', opts)

vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>Telescope find_files<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>fg', '<cmd>Telescope live_grep_args<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>fb', '<cmd>Telescope buffers<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>fx', '<cmd>Telescope file_browser<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>fs', '<cmd>Telescope treesitter<CR>', opts)
