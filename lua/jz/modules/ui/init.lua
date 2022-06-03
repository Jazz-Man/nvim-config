local ui = {}
local conf = require 'jz.modules.ui.config'

ui['sainnhe/sonokai'] = {config = conf.sonokai}

ui['norcalli/nvim-colorizer.lua'] = {event = 'BufRead', config = conf.colorizer}

ui['kyazdani42/nvim-web-devicons'] = {event = 'VimEnter', config = conf.devicon}

ui['nvim-lualine/lualine.nvim'] =
  {after = 'nvim-web-devicons', config = conf.lualine}

ui['akinsho/bufferline.nvim'] = {
    after = 'nvim-web-devicons',
    config = conf.bufferline,
    event = 'UIEnter',
    opt = true
}

ui['lukas-reineke/indent-blankline.nvim'] = {
  event = 'BufRead',
  config = conf.blankline,
}

return ui
