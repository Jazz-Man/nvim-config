return function(use)
  local conf = require('jz.modules.tools.config')

  use { 'tpope/vim-sensible' }

  use { 'tpope/vim-sleuth' }

  use { 'rmagatti/auto-session', config = conf.sessions }

  use { 'dstein64/vim-startuptime', cmd = 'StartupTime' }

  use { 'nathom/filetype.nvim' }

  use { 'NvChad/nvterm', config = conf.nvterm }

  use {
    'nvim-telescope/telescope.nvim',
    -- opt = true,
    config = conf.telescope,
    -- cmd = 'Telescope',
    wants = 'popup.nvim',
    requires = {
      'nvim-telescope/telescope-project.nvim',
      'nvim-telescope/telescope-ui-select.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
      {
        'nvim-telescope/telescope-frecency.nvim',
        requires = { 'tami5/sqlite.lua' }
      }
    }
  }

  use { 'rcarriga/nvim-notify', config = conf.notify }
end
