local util = rutils "init"

local keybinding = rutils "keybinding"

local m = keybinding.map
local c = keybinding.cmd

local fmt = string.format
local autocmd = vim.api.nvim_create_autocmd

local nav_keys = { h = "Left", j = "Down", k = "Up", l = "Right" }

m:group({
  ft = {

    "qf",
    "help",
    "man",
    "floaterm",
    "lspinfo",
    "lsp-installer",
    "null-ls-info",
  },
}, function(args) m:nnoremap():buffer(args.buf):k("q"):c(c:cmd "close") end)

m:group({ desc = "Duplicate" }, function()
  m:nnoremap():desc("line downwards"):k("<C-d>"):c(c:cmd "copy.")
  m:vnoremap():desc("selection downwards"):k("<C-d>"):c(c:cmd "copy.")
end)

m:xmap():desc("copy selection to clipboard"):k("Y"):c '"+y'

m:nmap():desc("copy entire file contents"):k("yY"):c(function() util.preserve 'norm ggVG"+y' end)

m:nmap():desc("Go to file under cursor (new tab)"):k([[gF]]):c [[<C-w>gf]]

return {
  n = {
    ["vK"] = { [[<C-\><C-N>:help <C-R><C-W><CR>]], desc = "Show help for current line or string" },
  },
}
