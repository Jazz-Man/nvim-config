return function( use )
  local conf = require 'jz.modules.ui.config'

  use { 'sainnhe/sonokai', config = conf.sonokai }

  use 'folke/lsp-colors.nvim'

  use {
    'norcalli/nvim-colorizer.lua',
    event = 'BufRead',
    config = conf.colorizer
  }

  use {
    'kyazdani42/nvim-web-devicons',
    event = 'VimEnter',
    config = conf.devicon
  }

  use {
    'kyazdani42/nvim-tree.lua',
    config = conf.nvim_tree,
    requires = { 'kyazdani42/nvim-web-devicons' }
  }

  use {
    'nvim-lualine/lualine.nvim',
    after = { 'nvim-web-devicons' },
    config = conf.lualine
  }

  use {
    'akinsho/bufferline.nvim',
    after = 'nvim-web-devicons',
    config = conf.bufferline,
    event = 'UIEnter',
    opt = true
  }
end
