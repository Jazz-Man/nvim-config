return function( use )
  local conf = require 'jz.modules.editor.config'

  use { 'numToStr/Comment.nvim', config = conf.comment }

  use { 'tpope/vim-surround', event = 'InsertEnter' }

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = conf.treesitter,
    requires = {
      { 'nvim-treesitter/nvim-treesitter-textobjects', after = 'nvim-treesitter' },
      { 'nvim-treesitter/nvim-treesitter-refactor', after = 'nvim-treesitter' },
      { 'JoosepAlviste/nvim-ts-context-commentstring', after = 'nvim-treesitter' },
      {
        'nvim-treesitter/playground',
        after = 'nvim-treesitter',
        cmd = 'TSPlayground'
      }
    }
  }

  use {
    'windwp/nvim-ts-autotag',
    config = conf.ts_autotag,
    after = 'nvim-treesitter'
    -- ft = conf.ts_autotag_filetypes
  }

  use { 'booperlv/nvim-gomove', config = conf.nvim_gomove }

  use {
    'mbbill/undotree',
    opt = true,
    config = conf.vim_mundo,
    cmd = { 'UndotreeToggle', 'UndotreeHide', 'UndotreeShow', 'UndotreeFocus' }
  }

  use {
    'lukas-reineke/indent-blankline.nvim',
    event = 'BufRead',
    config = conf.blankline
  }

end
