local packages = {
  {"wbthomason/packer.nvim", opt = true},
  "justinmk/vim-dirvish",
  {"tpope/vim-vinegar"},
  {"tpope/vim-commentary"},
  {"tpope/vim-fugitive"},
  {"tpope/vim-git"},
  {"tpope/vim-repeat"},
  {"tpope/vim-surround"},
  {"tpope/vim-ragtag"},
  {
      "Yohannfra/Nvim-Switch-Buffer",
      cmd = "SwitchBuffer",
      keys = "S"
  },
  {
    "mhartington/formatter.nvim",
    config = "require [[config/formatter]]"
  },
  {
    "vim-airline/vim-airline",
    requires = {"hzchirs/vim-material"}
  },
  {
    "norcalli/nvim-colorizer.lua",
    config = "require'colorizer'.setup()"
  },
  {
    "neovim/nvim-lspconfig",
    config = "require [[config/lsp]]",
    requires = {
      {"nvim-lua/completion-nvim"},
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
  }
}

return packages
