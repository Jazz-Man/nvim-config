return function(use)
  local conf = require 'jz.modules.vcs.config'

  use {
    'TimUntersberger/neogit',
    requires = 'nvim-lua/plenary.nvim',
    cmd = 'Neogit',
    config = conf.neogit
  }

  use {
    'lewis6991/gitsigns.nvim',
    requires = 'nvim-lua/plenary.nvim',
    event = {
      'BufRead'
      -- "BufReadPre",
    },
    config = conf.gitsigns
  }

  use {
    'sindrets/diffview.nvim',
    cmd = {
      'DiffviewOpen',
      'DiffviewFileHistory',
      'DiffviewFocusFiles',
      'DiffviewToggleFiles',
      'DiffviewRefresh'
    },
    requires = { 'nvim-lua/plenary.nvim', 'kyazdani42/nvim-web-devicons' },
    config = conf.diffview
  }
end
