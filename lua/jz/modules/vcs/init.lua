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
    event = { 'BufRead' },
    config = conf.gitsigns
  }

  use {
    'f-person/git-blame.nvim',
    event = { 'BufRead' },
    config = conf.git_blame
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
    requires = 'nvim-lua/plenary.nvim',
    config = conf.diffview
  }
end
