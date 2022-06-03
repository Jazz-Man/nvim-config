local tools = {}
local conf = require('jz.modules.tools.config')

tools['nvim-lua/plenary.nvim'] = {opt = false}
tools['nvim-lua/plenary.nvim'] = {opt = false}

-- tools['rmagatti/auto-session'] = {config = conf.sessions}

tools['dstein64/vim-startuptime'] = {cmd = 'StartupTime'}

tools['nathom/filetype.nvim'] = {config = function() vim.g.did_load_filetypes =
  1 end}

tools['NvChad/nvterm'] = {config = conf.nvterm}

tools['nvim-telescope/telescope.nvim'] = {
    -- opt = true,
    config = conf.telescope,
    cmd = 'Telescope',
    requires = {
        'nvim-lua/popup.nvim',
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope-project.nvim',
        'nvim-telescope/telescope-ui-select.nvim',
        {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'},
        {'nvim-telescope/telescope-frecency.nvim', requires = {
            'tami5/sqlite.lua'
        }}
    }
}

-- tools['rcarriga/nvim-notify'] = {
--   opt = false,
--   config = conf.notify,
-- }

return tools
