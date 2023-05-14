return {
  -- {
  --   'sainnhe/sonokai',
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     -- load the colorscheme here
  --     local sonokai_options = {
  --       sonokai_style = 'atlantis',
  --       sonokai_enable_italic = 1,
  --       sonokai_disable_italic_comment = 1,
  --       sonokai_better_performance = 1
  --     }

  --     for option, value in pairs(sonokai_options) do vim.g[option] = value end

  --     vim.cmd.colorscheme 'sonokai'
  --   end
  -- }
  -- catppuccin
  -- {
  --   "catppuccin/nvim",
  --   lazy = false, -- make sure we load this during startup if it is your main colorscheme
  --   priority = 1000, -- make sure to load this before all the other start plugins
  --   name = "catppuccin",
  --   config = function()
  --       -- load the colorscheme here
  --       vim.cmd.colorscheme "catppuccin"
  --     end,
  -- },
  -- OneNord
  {
    'rmehri01/onenord.nvim',
    lazy = false,
    priority = 1000,
    opts = { theme = 'dark' }
  }
}
