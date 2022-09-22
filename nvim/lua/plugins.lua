local use = require'packer'.use

require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'

  use 'jose-elias-alvarez/null-ls.nvim'

  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'

  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  use 'tpope/vim-commentary'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-surround'
  use 'airblade/vim-gitgutter'
  use 'mg979/vim-visual-multi'
  use 'editorconfig/editorconfig-vim'

  use 'lukas-reineke/indent-blankline.nvim'
  use 'ojroques/nvim-hardline'
  use 'sainnhe/sonokai'
end)
