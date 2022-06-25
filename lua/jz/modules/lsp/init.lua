return function( use )

  local conf = require 'jz.modules.lsp.config'

  use {
    'williamboman/nvim-lsp-installer',
    {
      'neovim/nvim-lspconfig',
      event = { 'BufReadPre', 'BufNewFile' },
      config = conf.lspconfig
    },
    {
      'jose-elias-alvarez/null-ls.nvim',
      after = 'nvim-lspconfig',
      config = conf.null_ls
    },
    {
      'ray-x/lsp_signature.nvim',
      after = 'nvim-lspconfig',
      config = conf.lsp_signature
    }
  }

  use {
    'folke/lua-dev.nvim',
    wants = 'nvim-lspconfig',
    ft = { 'lua' },
    config = conf.lua_lsp
  }

  use {
    'crispgm/nvim-go',
    wants = 'nvim-lspconfig',
    ft = { 'go', 'gomod', 'gotmpl' },
    config = conf.nvim_go
  }

  use {
    'b0o/schemastore.nvim',
    ft = { 'json', 'jsonc' },
    wants = 'nvim-lspconfig',
    config = conf.jsonls_lsp
  }

  use {
    'someone-stole-my-name/yaml-companion.nvim',
    wants = 'nvim-lspconfig',
    ft = { 'yaml', 'yaml.docker-compose', 'yml' },
    requires = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' },
    config = conf.yaml_lsp
  }

  use {
    'nanotee/sqls.nvim',
    config = conf.sql_lsp,
    ft = { 'sql', 'mysql', 'plsql' },
    wants = 'nvim-lspconfig',
    requires = {
      {
        'kristijanhusak/vim-dadbod-completion',
        after = { 'sqls.nvim' },
        setup = function()
          vim.cmd(
            [[autocmd FileType sql setlocal omnifunc=vim_dadbod_completion#omni]]
          )
        end
      }
    }
  }

  use {
    'jose-elias-alvarez/nvim-lsp-ts-utils',
    ft = {
      'javascript',
      'javascriptreact',
      'javascript.jsx',
      'typescript',
      'typescriptreact',
      'typescript.tsx'
    },
    wants = 'nvim-lspconfig',
    config = conf.ts_lsp
  }

  use {
    'L3MON4D3/LuaSnip',
    config = conf.luasnip,
    event = 'InsertEnter',
    requires = { { 'rafamadriz/friendly-snippets', event = 'InsertEnter' } }
  }

  use {
    'hrsh7th/nvim-cmp',
    config = conf.cmp,
    after = { 'LuaSnip' },
    -- The completion plugin
    requires = {
      { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-path', after = 'nvim-cmp' },
      { 'saadparwaiz1/cmp_luasnip', after = { 'nvim-cmp', 'LuaSnip' } },
      { 'hrsh7th/cmp-nvim-lsp', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-nvim-lua', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-nvim-lsp-document-symbol', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-nvim-lsp-signature-help', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-omni', after = 'nvim-cmp' },
      { 'ray-x/cmp-treesitter', after = 'nvim-cmp' },
      { 'windwp/nvim-autopairs', config = conf.autopairs, after = 'nvim-cmp' }
    }
  }

  use {
    'simrat39/symbols-outline.nvim',
    config = conf.symbols_outline,
    cmd = { 'SymbolsOutline', 'SymbolsOutlineOpen', 'SymbolsOutlineClose' }
  }

  use {
    'folke/trouble.nvim',
    requires = 'kyazdani42/nvim-web-devicons',
    config = conf.trouble
    -- cmd = { 'Trouble', 'TroubleClose', 'TroubleToggle', 'TroubleRefresh' }
  }
end
