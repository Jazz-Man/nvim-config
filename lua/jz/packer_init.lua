local vim = assert(vim)

-----------------------------------------------------------
-- Plugin manager configuration file
-----------------------------------------------------------
-- Plugin manager: packer.nvim
-- url: https://github.com/wbthomason/packer.nvim
-- Automatically install packer
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({
    'git', 'clone', '--depth', '1',
    'https://github.com/wbthomason/packer.nvim', install_path
  })
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Use a protected call so we don't error out on first use

local packer = require("packer")
--
-- Have packer use a popup window

packer.init {
  ensure_dependencies = true,
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end
  },
  autoremove = true
}

-- Install plugins
return packer.startup(function(use)
  -- speed up 'require', must be the first plugin
  use { "lewis6991/impatient.nvim" }

  use { 'wbthomason/packer.nvim' } -- packer can manage itself

  -- Analyze startuptime
  use { 'dstein64/vim-startuptime', cmd = 'StartupTime' }


  use 'norcalli/nvim_utils'

  use 'tjdevries/lazy.nvim'

  use 'nathom/filetype.nvim'

  use 'NvChad/nvterm'

  use {
    "numToStr/Comment.nvim",
    module = "Comment",
    config = "require ('jz.config.comment')",
    keys = { 'gc', 'gl' }
  }

  -- UI

  use "sainnhe/sonokai"

  use {
    "norcalli/nvim-colorizer.lua",
    config = "require('jz.config.colorizer')",
    event = "BufRead",
  }

  -- use "nvim-lualine/lualine.nvim"

  use {
    "nvim-lualine/lualine.nvim",
    after = "nvim-web-devicons",
    config = "require('jz.config.statusline')"
  }

  use {
    "kyazdani42/nvim-web-devicons",
    config = function()
      require('nvim-web-devicons').setup({ default = true })
    end,
    event = "VimEnter"
  }

  -- UI Helpers

  use({ "nvim-lua/plenary.nvim" })

  use({ "nvim-lua/popup.nvim" })


  use { "RishabhRD/popfix" }

  -- Go Language
  use { "crispgm/nvim-go", config = "require ('jz.config.go')", ft = { "go" } }

  -- LSP
  use { 'neovim/nvim-lspconfig', event = 'BufRead' }
  use {
    "williamboman/nvim-lsp-installer",
    config   = "require('jz.lsp')",
    requires = {
      "jose-elias-alvarez/null-ls.nvim",
      "jose-elias-alvarez/nvim-lsp-ts-utils",
      "ray-x/lsp_signature.nvim"
    },
    after    = { 'nvim-lspconfig' }
  }

  -- Autocompletion & snippets
  use {
    "rafamadriz/friendly-snippets",
    module = "cmp_nvim_lsp",
    event = "InsertEnter",
  }


  use {
    'L3MON4D3/LuaSnip',
    wants = "friendly-snippets",
    after = "nvim-cmp",
    config = "require('jz.config.luasnip')",
  }


  use {
    "hrsh7th/nvim-cmp",
    config = "require('jz.config.cmp')",
    after = "friendly-snippets",
    -- The completion plugin
    requires = {
      "hrsh7th/cmp-buffer", -- buffer completions
      "hrsh7th/cmp-path", -- path completions,
      {"saadparwaiz1/cmp_luasnip", after = "LuaSnip"}, -- snippet completions
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua", -- nvim-cmp source for neovim Lua API.
      "hrsh7th/cmp-nvim-lsp-document-symbol", -- nvim-cmp source for textDocument/documentSymbol via nvim-lsp.
      "hrsh7th/cmp-nvim-lsp-signature-help", -- nvim-cmp source for displaying function signatures with the current parameter emphasized:
      "hrsh7th/cmp-omni", -- nvim-cmp source for omnifunc.
      "ray-x/cmp-treesitter", -- nvim-cmp source for treesitter nodes.
      "onsails/lspkind-nvim" -- This tiny plugin adds vscode-like pictograms to neovim built-in lsp
    },
  }



  use {
    'nvim-telescope/telescope.nvim',
    -- opt = true,
    setup = "require ('jz.telescope.mappings')",
    config = "require ('jz.telescope')",
    -- cmd = "Telescope",
    requires = {
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-packer.nvim',
      'nvim-telescope/telescope-ui-select.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    }
  }

  use {
    "nvim-treesitter/nvim-treesitter",
    config = "require('jz.config.treesitter')",
    run = ':TSUpdate',
    event = "BufRead",
    requires = {
      { "nvim-treesitter/nvim-treesitter-refactor", after = { 'nvim-treesitter' } },
      { "nvim-treesitter/nvim-treesitter-textobjects", after = { 'nvim-treesitter' } },
      { "JoosepAlviste/nvim-ts-context-commentstring", after = { 'nvim-treesitter' } }
    }
  }

  use {
    "ThePrimeagen/refactoring.nvim",
    setup = "require ('jz.config.refactoring.mappings')",
    config = "require('jz.config.refactoring')",
    require = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter"
    },
    after = { 'nvim-treesitter' }
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then require('packer').sync() end
end)
