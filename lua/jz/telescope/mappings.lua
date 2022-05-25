local utils = require 'jz.utils'



utils.map_tele('n', '<leader><F1>', "help_tags")

utils.map_tele('n', '<leader>,', "buffers")
utils.map_tele('n', '<leader>zf', "find_files")
-- Telescope Meta
utils.map_tele('n', "<leader>z?", "builtin")


-- Nvim & Dots
utils.map_tele('n', '<leader>zen', "edit_neovim")
