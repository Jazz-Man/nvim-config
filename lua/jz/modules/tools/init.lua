return function(use)
  local conf = require('jz.modules.tools.config')

  --- Please Vim, stop with these swap file messages. Just switch to the correct window!
  use 'gioele/vim-autoswap'

  use 'Iron-E/nvim-libmodal'

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
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
      },
      {
        'nvim-telescope/telescope-frecency.nvim',
        requires = { 'tami5/sqlite.lua' }
      }
    }
  }

  use { 'rcarriga/nvim-notify', config = conf.notify }
end
