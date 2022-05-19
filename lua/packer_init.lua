-----------------------------------------------------------
-- Plugin manager configuration file
-----------------------------------------------------------
-- Plugin manager: packer.nvim
-- url: https://github.com/wbthomason/packer.nvim
-- Automatically install packer
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({
    'git', 'clone', '--depth', '1',
    'https://github.com/wbthomason/packer.nvim', install_path
  })
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Use a protected call so we don't error out on first use

local packer = prequire("packer")
--
-- Have packer use a popup window
if packer then


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
    use { 'wbthomason/packer.nvim' } -- packer can manage itself

    use 'norcalli/nvim_utils'

    -- UI
    use {
      { "sainnhe/sonokai" },
      { "norcalli/nvim-colorizer.lua" },
      {
        "kyazdani42/nvim-web-devicons",
        config = function()
          require('nvim-web-devicons').setup({
            default = true
          })
        end,

      },
      { "nvim-lualine/lualine.nvim" }

    }

    -- UI Helpers

    use({ "nvim-lua/plenary.nvim", as = "lua_plenary" })

    use({ "nvim-lua/popup.nvim", as = "lua_popup" })

    use({ "RishabhRD/lspactions",
      wants = {
        "lua_plenary",
        "lua_popup"
      }
    })

    use {
      "RishabhRD/popfix",
      as = "popfix"
    }

    -- Go Language
    use {
      "crispgm/nvim-go",
      config = "require [[config/go]]",
      ft = {
        "go"
      }
    }


    -- LSP
    use {
      "neovim/nvim-lspconfig",
      config = "require [[lsp]]",
      wants = {
        "cmp-nvim-lsp",
        "null-ls.nvim",
        "nvim-lsp-installer",
      },
      requires = {
        { "RishabhRD/nvim-lsputils", wants = { "popfix" } }, -- TODO remove
        "williamboman/nvim-lsp-installer",
        "jose-elias-alvarez/null-ls.nvim",
        "jose-elias-alvarez/nvim-lsp-ts-utils"
      }
    }

    -- cmp plugins
    use {
      "hrsh7th/nvim-cmp", -- The completion plugin
      requires = {
        "hrsh7th/cmp-buffer", -- buffer completions
        "hrsh7th/cmp-path", -- path completions,
        -- "hrsh7th/cmp-cmdline",
        "saadparwaiz1/cmp_luasnip", -- snippet completions
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lua", -- nvim-cmp source for neovim Lua API.
        "hrsh7th/cmp-nvim-lsp-document-symbol", -- nvim-cmp source for textDocument/documentSymbol via nvim-lsp.
        "hrsh7th/cmp-nvim-lsp-signature-help", -- nvim-cmp source for displaying function signatures with the current parameter emphasized:
        "hrsh7th/cmp-omni", -- nvim-cmp source for omnifunc.
        "ray-x/cmp-treesitter", -- nvim-cmp source for treesitter nodes.
        "L3MON4D3/LuaSnip", -- snippet engine
        "rafamadriz/friendly-snippets", -- a bunch of snippets to use
        "onsails/lspkind-nvim" -- This tiny plugin adds vscode-like pictograms to neovim built-in lsp
      }

    }

    use {
      'nvim-telescope/telescope.nvim',
      as = "telescope",
      -- opt = true,
      -- cmd = { "Telescope" },
      -- module = "telescope",
      -- keys = {"<leader><space>", "<leader>fz", "<leader>pp"},
      -- config = "require [[config/telescope]]",
      wants = {
        "lua_plenary",
        "telescope-fzf-native.nvim",
        "telescope-packer.nvim"
      },
      requires = {
        'nvim-telescope/telescope-packer.nvim',
        { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
      }
    }

    use {
      "nvim-treesitter/nvim-treesitter",
      -- as = "treesitter",
      config = "require [[config/treesitter]]",
      run = ':TSUpdate',
      -- opt = true,
      --event = "BufRead",
      requires = {
        "nvim-treesitter/nvim-treesitter-refactor",
        "nvim-treesitter/nvim-treesitter-textobjects",
        "JoosepAlviste/nvim-ts-context-commentstring",
        "numToStr/Comment.nvim"
      }
    }

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then require('packer').sync() end
  end)

end
