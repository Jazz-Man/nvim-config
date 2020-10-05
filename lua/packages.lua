local packages = {
  {"wbthomason/packer.nvim", opt = true},
  {
    "hzchirs/vim-material",
    config = function()
      vim.api.nvim_set_option("background", "dark")
      vim.api.nvim_command("colorscheme vim-material")
      vim.api.nvim_set_var("airline_theme", "material")
    end
  },
  {
    "kyazdani42/nvim-tree.lua",
    config = function()
      vim.api.nvim_set_var("lua_tree_side", "left")
      vim.api.nvim_set_var("lua_tree_width", 40)
      vim.api.nvim_set_var("lua_tree_ignore", {".git", "node_modules", ".cache"})
      vim.api.nvim_set_var("lua_tree_auto_open", 1)
      vim.api.nvim_set_var("lua_tree_auto_close", 1)
      vim.api.nvim_set_var("lua_tree_follow", 1)
      vim.api.nvim_set_var("lua_tree_indent_markers", 1)
      vim.api.nvim_set_var("lua_tree_hide_dotfiles", 0)
      vim.api.nvim_set_var("lua_tree_git_hl", 1)
      vim.api.nvim_set_var("lua_tree_root_folder_modifier", ":~")
      vim.api.nvim_set_var("lua_tree_tab_open", 1)
    end,
    requires = {
      "kyazdani42/nvim-web-devicons"
    }
  },
  "euclidianAce/BetterLua.vim",
  "tjdevries/nlua.nvim",
  "svermeulen/vimpeccable",
  {"tpope/vim-vinegar"},
  {"tpope/vim-commentary"},
  {
    "tpope/vim-fugitive"
  },
  {"tpope/vim-git"},
  {"tpope/vim-repeat"},
  {"tpope/vim-surround"},
  {"tpope/vim-ragtag"},
  {
    "mhartington/formatter.nvim",
    config = "require [[config/formatter]]"
  },
  {
    "vim-airline/vim-airline",
    setup = function()
      vim.api.nvim_set_option("termguicolors", true)
    end,
    config = function()
      vim.api.nvim_set_var("airline#extensions#tabline#enabled", 1)
      vim.api.nvim_set_var("airline#extensions#tabline#left_sep", " ")
      vim.api.nvim_set_var("airline#extensions#tabline#left_alt_sep", "|")
      vim.api.nvim_set_var("airline#extensions#tabline#formatter", "unique_tail_improved")
      vim.api.nvim_set_var("airline#extensions#tabline#buffer_nr_show", 1)
    end
  },
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require "colorizer".setup(
        {
          "*"
        },
        {
          rgb_fn = true,
          hsl_fn = true,
          css = true,
          css_fn = true,
          mode = "background"
        }
      )
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = "require [[config/lsp]]",
    requires = {
      {
        "nvim-lua/completion-nvim",
        config = function()
          vim.g.completion_enable_auto_hover = 1
          vim.g.completion_auto_change_source = 1
          vim.g.completion_matching_ignore_case = 1
          vim.g.completion_enable_auto_paren = 1
        end
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
