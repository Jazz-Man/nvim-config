local packages = {
  {"wbthomason/packer.nvim", opt = true},
  {
    "sainnhe/sonokai",
    config = "require [[config/theme]]"
  },
  {
    "kyazdani42/nvim-tree.lua",
    config = "require [[config/nvim-tree]]",
    requires = {
      "kyazdani42/nvim-web-devicons"
    }
  },
  {
    "mileszs/ack.vim",
    cmd = {
      "Ack",
      "AckAdd",
      "AckFromSearch",
      "LAck",
      "LAckAdd",
      "AckFile",
      "AckHelp",
      "LAckHelp",
      "AckWindow",
      "LAckWindow"
    }
  },
  "svermeulen/vimpeccable",
  {"tpope/vim-commentary"},
  {
    "tpope/vim-fugitive"
  },
  {"tpope/vim-git"},
  {"tpope/vim-repeat"},
  {"tpope/vim-surround"},
  {"tpope/vim-ragtag"},
  -- {
  --   "sbdchd/neoformat",
  --   config = "require [[config/formatter]]"
  -- },
  {
    "vim-airline/vim-airline",
    setup = function()
      vim.api.nvim_set_option("termguicolors", true)
    end,
    config = "require [[config/airline]]"
  },
  {
    "norcalli/nvim-colorizer.lua",
    config = "require [[config/colorizer]]"
  },
  {
    "neovim/nvim-lspconfig",
    config = "require [[config/lsp]]",
    requires = {
      {
        "nvim-lua/completion-nvim",
        config = "require [[config/completion]]"
      },
      {
        "mhartington/formatter.nvim",
        config = "require [[config/formatter]]"
      },
      {
        "nvim-lua/diagnostic-nvim",
        config = "require [[config/diagnostic]]"
      },
      {"nvim-lua/lsp-status.nvim"}
    }
  },
  {
    "nvim-treesitter/nvim-treesitter",
    config = "require [[config/treesitter]]",
    requires = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/nvim-treesitter-refactor",
      "nvim-treesitter/playground"
    }
  },
  {
    "nvim-treesitter/completion-treesitter",
    config = "require [[config/completion]]",
    requires = {
      "nvim-lua/completion-nvim"
    }
  },
  {"skywind3000/vim-quickui"}
}

return packages
