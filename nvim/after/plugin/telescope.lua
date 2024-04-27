require('telescope').setup {
  extensions = {
    ['ui-select'] = {
      require('telescope.themes').get_dropdown {},
    },
    live_grep_args = {
      auto_quoting = true,
    },
  },
  defaults = {
    borderchars = { "┈", "┊", "┈", "┊", "┌", "┐", "┘", "└" },
    prompt_prefix = '  ',
    selection_caret = '» ',
  },
}

require('telescope').load_extension('live_grep_args')
require('telescope').load_extension('file_browser')
require('telescope').load_extension('ui-select')
