local use = require'packer'.use

require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  use 'nvim-lua/plenary.nvim'

  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-nvim-lua'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'

  use 'jose-elias-alvarez/null-ls.nvim'

  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'

  use 'nvim-telescope/telescope.nvim'
  use 'nvim-telescope/telescope-file-browser.nvim'
  use 'nvim-telescope/telescope-ui-select.nvim'

  use 'tpope/vim-commentary'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-surround'
  use 'airblade/vim-gitgutter'
  use 'mg979/vim-visual-multi'

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }
  use 'nvim-treesitter/nvim-treesitter-textobjects'
  use 'nvim-treesitter/nvim-treesitter-context'
  use 'lukas-reineke/indent-blankline.nvim'
  use 'editorconfig/editorconfig-vim'

  use 'ojroques/nvim-hardline'
  use 'sainnhe/sonokai'
  use 'sainnhe/everforest'
  use 'joshdick/onedark.vim'
  use 'drewtempelmeyer/palenight.vim'
  use 'rakr/vim-one'
  use 'w0ng/vim-hybrid'
  use 'romainl/Apprentice'
  use 'junegunn/seoul256.vim'

  use 'AlessandroYorba/Sierra'
end)
