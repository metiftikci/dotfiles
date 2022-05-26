local use = require'packer'.use

require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'

  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'

  use 'tpope/vim-fugitive'
  use 'airblade/vim-gitgutter'
  use 'tpope/vim-commentary'

  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  use 'morhetz/gruvbox'
end)

local cmp = require'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
  })
})

cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

local opts = { noremap=true, silent=true }

vim.api.nvim_set_keymap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

require('lspconfig')['csharp_ls'].setup {
  on_attach = on_attach,
  capabilities = capabilities
}

vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>Telescope find_files<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>fg', '<cmd>Telescope live_grep<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>fb', '<cmd>Telescope buffers<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', opts)

vim.opt.colorcolumn = "120"                                -- Show ruler on 120. column
vim.opt.completeopt = {'menuone', 'noinsert', 'noselect'}  -- Completion options (for deoplete)
vim.opt.expandtab = true                                   -- Use spaces instead of tabs
vim.opt.hidden = true                                      -- Enable background buffers
vim.opt.ignorecase = true                                  -- Ignore case
vim.opt.joinspaces = false                                 -- No double spaces with join
vim.opt.list = true                                        -- Show some invisible characters
vim.opt.listchars = vim.opt.listchars + "space:."          -- Show dot for space
vim.opt.number = true                                      -- Show line numbers
vim.opt.relativenumber = true                              -- Relative line numbers
vim.opt.scrolloff = 4                                      -- Lines of context
vim.opt.shiftround = true                                  -- Round indent
vim.opt.shiftwidth = 2                                     -- Size of an indent
vim.opt.sidescrolloff = 8                                  -- Columns of context
vim.opt.smartcase = true                                   -- Do not ignore case with capitals
vim.opt.smartindent = true                                 -- Insert indents automatically
vim.opt.signcolumn = 'yes'                                 -- Show sign column
vim.opt.splitbelow = true                                  -- Put new windows below current
vim.opt.splitright = true                                  -- Put new windows right of current
vim.opt.tabstop = 2                                        -- Number of spaces tabs count for
vim.opt.termguicolors = true                               -- True color support
vim.opt.wildmode = {'list', 'longest'}                     -- Command-line completion mode
vim.opt.wrap = false                                       -- Disable line wrap

vim.cmd("autocmd vimenter * ++nested colorscheme gruvbox")
vim.cmd("autocmd vimenter * hi Visual cterm=NONE ctermfg=NONE ctermbg=darkgray")
