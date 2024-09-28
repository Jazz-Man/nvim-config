local util = rutils "init"

-- local keybinding = rutils "keybinding"
--
-- pp(keybinding)

-- local m = keybinding.map
-- local c = keybinding.cmd

local fmt = string.format
local autocmd = vim.api.nvim_create_autocmd

local nav_keys = { h = "Left", j = "Down", k = "Up", l = "Right" }

-- m:group({
--   ft = {
--
--     "qf",
--     "help",
--     "man",
--     "floaterm",
--     "lspinfo",
--     "lsp-installer",
--     "null-ls-info",
--   },
-- }, function(args) m:nnoremap():buffer(args.buf):k("q"):c(c:cmd "close") end)
--
-- m:group({ desc = "Duplicate" }, function()
--   m:nnoremap():desc("line downwards"):k("<C-d>"):c(c:cmd "copy.")
--   m:vnoremap():desc("selection downwards"):k("<C-d>"):c(c:cmd "copy.")
-- end)
--
-- m:group({ prefix = "s", desc = "Split" }, function()
--   m:nnoremap():desc("left above"):k("h"):c(c:cmd "leftabove vsplit")
--   m:nnoremap():desc("below right"):k("j"):c(c:cmd "belowright split")
--   m:nnoremap():desc("above left"):k("k"):c(c:cmd "aboveleft split")
--   m:nnoremap():desc("right below"):k("l"):c(c:cmd "rightbelow vsplit")
-- end)

return {
  n = {
    ["vK"] = { [[<C-\><C-N>:help <C-R><C-W><CR>]], desc = "Show help for current line or string" },
    ["gF"] = { [[<C-w>gf]], desc = "Go to file under cursor (new tab)" },
  },
}
