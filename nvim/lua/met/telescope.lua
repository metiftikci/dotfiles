require('telescope').setup{
  extensions = {
    ['ui-select'] = {
      require('telescope.themes').get_dropdown{},
    },
  },
}
require('telescope').load_extension('file_browser')
require('telescope').load_extension('ui-select')

local opts = { noremap=true, silent=true }

vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>Telescope find_files<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>fg', '<cmd>Telescope live_grep<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>fb', '<cmd>Telescope buffers<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>fx', '<cmd>Telescope file_browser<CR>', opts)
