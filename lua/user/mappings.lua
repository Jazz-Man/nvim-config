local util = require 'lua.jz.utils.init'
-- local m = require(astronvim.install.config .. "/jz/utils/keybinding.lua").map
-- local c = require("jz.utils.keybinding").cmd

local fmt = string.format
local autocmd = vim.api.nvim_create_autocmd

local nav_keys = { h = "Left", j = "Down", k = "Up", l = "Right" }

-- m:group({
--   ft = {

--     "qf",
--     "help",
--     "man",
--     "floaterm",
--     "lspinfo",
--     "lsp-installer",
--     "null-ls-info",
--   },
-- }, function(args) m:nnoremap():buffer(args.buf):k("q"):c(c:cmd "close") end)

-- m:group({ desc = "Duplicate" }, function()
--   m:nnoremap():desc("line downwards"):k("<C-d>"):c(c:cmd "copy.")
--   m:vnoremap():desc("selection downwards"):k("<C-d>"):c(c:cmd "copy.")
-- end)

return {
  n = {
    ["vK"] = { [[<C-\><C-N>:help <C-R><C-W><CR>]], desc = "Show help for current line or string" },
  },
}
