local lga_actions = require('telescope-live-grep-args.actions')

require('telescope').setup{
  extensions = {
    ['ui-select'] = {
      require('telescope.themes').get_dropdown{},
    },
    live_grep_args = {
      auto_quoting = true,
    },
  },
}

require('telescope').load_extension('live_grep_args')
require('telescope').load_extension('file_browser')
require('telescope').load_extension('ui-select')

local opts = { noremap=true, silent=true }

vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>Telescope find_files<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>fg', '<cmd>Telescope live_grep_args<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>fb', '<cmd>Telescope buffers<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>fx', '<cmd>Telescope file_browser<CR>', opts)
