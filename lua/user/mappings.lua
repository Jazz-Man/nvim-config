local util = require 'jz.utils.init'
local m = require'jz.utils.keybinding'.map
local c = require'jz.utils.keybinding'.cmd

local fmt = string.format
local autocmd = vim.api.nvim_create_autocmd

local nav_keys = { h = 'Left', j = 'Down', k = 'Up', l = 'Right' }


local save_and_go = { [[<Esc><Cmd>silent! update | redraw<CR>]], desc = "Save and go to Normal mode" }

return {
  n = {
    ["vK"] = { [[<C-\><C-N>:help <C-R><C-W><CR>]], desc = "Save File Shortcut" },
  },
  i = {
    ["<C-S>"] = save_and_go,
  },
  x = {
    ["<C-S>"] = save_and_go,
  },
}
