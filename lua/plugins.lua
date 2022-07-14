vim.cmd [[packadd packer.nvim]]

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

require('packer').startup({function()
  -- Packaging
  use 'wbthomason/packer.nvim'    -- configured 
  use 'lewis6991/impatient.nvim'  -- configured
  use 'nathom/filetype.nvim'      -- configured
  -- Completion and linting
  use 'neovim/nvim-lspconfig'
  use 'williamboman/nvim-lsp-installer'
  use {
    'folke/trouble.nvim',
    requires = "kyazdani42/nvim-web-devicons",
  }                               -- configured
  use 'ray-x/lsp_signature.nvim'
  use 'kosayoda/nvim-lightbulb'
  -- Treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
  }
  -- Completion
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-nvim-lua'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'
  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'

  -- Styling
  use 'EdenEast/nightfox.nvim'

  -- Formatting
  use 'prettier/vim-prettier'
  
  -- Wiki
  use 'vimwiki/vimwiki'
end,
config = {
	display = {
		open_fn = require("packer.util").float,
	},
}})
--========================================================================--

require('nightfox').setup({
  options = {
    transparent = true,
    alt_nv = true,
    terminal_colors = true,
    styles = {
      comments = "italic",
      functions = "bold"
    },
  },
})

vim.cmd("colorscheme nightfox")

require('nvim-treesitter.configs').setup({
  ensure_installed = "maintained",
  highlight = { enable = true },
})

--=======================================================================--
 -- Setup nvim-cmp.
local cmp = require'cmp'

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  mapping = {
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  },
  sources = cmp.config.sources({
    { name = 'nvim_lua' },
    { name = 'nvim_lsp' },
    { name = 'path'},
    { name = 'luasnip' }, -- For luasnip users.
    { name = 'buffer', keyword_length = 5},
  }),
})

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

  -- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
capabilities.textDocument.completion.completionItem.snippetSupport = true

local lspconfig = require('lspconfig')
local servers = {
  'sumneko_lua',
  --'pyright',
  'julials',
  'jedi_language_server',
  'tsserver',
  'emmet_ls',
  'html',
  'cssls'
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    capabilities = capabilities,
  }
end

