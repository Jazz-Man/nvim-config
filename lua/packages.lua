local packages = {
  {"wbthomason/packer.nvim"},
  -- "nvim-lua/plenary.nvim",
  ---
  --- Appearance
  ---
  {
    "sainnhe/sonokai",
    config = "require [[config/theme]]"
  },
  {
    "norcalli/nvim-colorizer.lua",
    config = "require [[config/colorizer]]"
  },
  {
    "vim-airline/vim-airline",
    config = "require [[config/airline]]"
  },
  {
    "kyazdani42/nvim-tree.lua",
    config = "require [[config/nvim-tree]]",
    requires = {
      "kyazdani42/nvim-web-devicons"
    }
  },
  -- {
  --   "mileszs/ack.vim",
  --   cmd = {
  --     "Ack",
  --     "AckAdd",
  --     "AckFromSearch",
  --     "LAck",
  --     "LAckAdd",
  --     "AckFile",
  --     "AckHelp",
  --     "LAckHelp",
  --     "AckWindow",
  --     "LAckWindow"
  --   }
  -- },
  "svermeulen/vimpeccable",
  "tpope/vim-commentary",
  "tpope/vim-fugitive",
  "tpope/vim-git",
  "tpope/vim-repeat",
  "tpope/vim-surround",
  "tpope/vim-ragtag",
  
  --- Completion
  
  {"hrsh7th/vim-vsnip", event = "InsertCharPre"},
  {"hrsh7th/vim-vsnip-integ", event = "InsertCharPre"},
  {"mattn/vim-sonictemplate", cmd = "Template"},
  {"Raimondi/delimitMate", event = "InsertCharPre"},
  -- {
  --   "mattn/emmet-vim",
  --    event = "InsertEnter",
  --   cmd = {
  --     "Emmet",
  --     "EmmetInstall"
  --   },
  --   ft = {
  --     "html",
  --     "css",
  --     "scss",
  --     "javascript",
  --     "javascriptreact",
  --     "typescript",
  --     "typescriptreact"
  --   }
  -- },
  {
    "nvim-lua/completion-nvim",
    config = "require [[config/completion]]",
    requires = {
      "nvim-treesitter/completion-treesitter",
      "steelsojka/completion-buffers",
      "kristijanhusak/completion-tags",
      "albertoCaroM/completion-tmux"
    }
  },
  -- LSP setup

  "RishabhRD/popfix",
  "RishabhRD/nvim-lsputils",
  {
    "neovim/nvim-lspconfig",
    config = "require [[config/lsp]]",
    requires = {
      {
        "mhartington/formatter.nvim",
        config = "require [[config/formatter]]"
      },
      "nvim-lua/lsp-status.nvim"
    }
  },
  -- {
  --   "nvim-treesitter/nvim-treesitter",
  --   -- config = "require [[config/treesitter]]",
  --    requires = {
  --     "nvim-treesitter/nvim-treesitter-textobjects",
  --     "nvim-treesitter/nvim-treesitter-refactor"
  --    },
  --    run = ':TSUpdate'
  -- },
  "skywind3000/vim-quickui"
}

return packages
