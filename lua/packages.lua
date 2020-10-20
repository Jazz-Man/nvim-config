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
  {
    "sbdchd/neoformat",
    config = "require [[config/formatter]]"
  },
  {
    "vim-airline/vim-airline",
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
      {"nvim-lua/diagnostic-nvim"},
      {"nvim-lua/lsp-status.nvim"}
    }
  },
  {
    "nvim-treesitter/nvim-treesitter",
    config = "require [[config/treesitter]]"
  },
  {
    "nvim-treesitter/completion-treesitter",
    requires = {
      "nvim-lua/completion-nvim"
    }
  },
  {"skywind3000/vim-quickui"}
}

return packages
