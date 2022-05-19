local K = require "utils/general"

local util = require("utils")

local opts = {noremap = true, silent = true}


-- Remap space as leader key
-- vim.keymap.set({'n', 'v'}, '<Space>', '<Nop>', opts)
util.nnoremap('<Space>', '<NOP>')
util.vnoremap('<Space>', '<NOP>')
vim.g.mapleader = " "
vim.g.maplocalleader = " "


-- Remap for dealing with word wrap
-- vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'",
--                {expr = true, silent = true})
-- vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'",
--                {expr = true, silent = true})

-- util.nnoremap('k',"v:count == 0 ? 'gk' : 'k'")

-- Diagnostic keymaps
-- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
-- util.nmap('<leader>e', vim.diagnostic.open_float)

-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- Using backtick for marks drops you on the exact column
-- K.Key_mapper("n", "`", "'")
-- K.Key_mapper("n", "'", "`")

-- Command mode
-- K.Key_mapper("n", ":", ";")
-- K.Key_mapper("n", ";", ":")
-- K.Key_mapper("x", ":", ";")
-- K.Key_mapper("x", ";", ":")


-- Completion
-- K.Key_mapper("i", "<C-]>", "<C-x><C-]>") -- Tag
-- K.Key_mapper("i", "<C-k>", "<C-x><C-o>") -- Omni
-- K.Key_mapper("i", "<C-n>", "<C-x><C-n>") -- Keyword
-- K.Key_mapper("i", "<C-f>", "<C-x><C-f>") -- File name
-- K.Key_mapper("i", "<C-l>", "<C-x><C-l>") -- Line
-- K.Key_mapper("i", "<C-d>", "<C-x><C-s>") -- Spell
-- K.Key_mapper("i", "<Tab>", [[pumvisible() ? '<C-n>' : '<Tab>']], true, true, false) -- Spell
-- K.Key_mapper("i", "<S-Tab>", [[pumvisible() ? '<C-p>' : '<S-Tab>']], true, true, false) -- Spell

-- Tabs
-- K.Key_mapper("n", "<Tab>", "gt")
-- K.Key_mapper("n", "<S-Tab>", "gT")

-- Center search
-- K.Key_mapper("n", "n", "nzvzz")
-- K.Key_mapper("n", "N", "Nzvzz")
-- K.Key_mapper("n", "*", "*zvzz")
-- K.Key_mapper("n", "#", "#zvzz")
-- K.Key_mapper("n", "``", "``zz")

-- Location list
-- K.Key_mapper("n", "<Up>", [[:call togglelist#ToggleList('Location List', 'l')<CR>]], true, false, true) -- Toggle Location list
-- K.Key_mapper("n", "]l", ":lnext<CR>")
-- K.Key_mapper("n", "[l", ":lprevious<CR>")
-- K.Key_mapper("n", "[L", ":lfirst<CR>")
-- K.Key_mapper("n", "]L", ":llast<CR>")
-- K.Key_mapper("n", "]<C-L>", ":lnfile<CR>")
-- K.Key_mapper("n", "[<C-L>", ":lpfile<CR>")

-- Quickfix list
-- K.Key_mapper("n", "<Down>", [[:call togglelist#ToggleList('Quickfix List', 'c')<CR>]], true, false, true) -- Toggle Quickfix list
-- K.Key_mapper("n", "]q", ":cnext<CR>")
-- K.Key_mapper("n", "[q", ":cprevious<CR>")
-- K.Key_mapper("n", "[Q", ":cfirst<CR>")
-- K.Key_mapper("n", "]Q", ":clast<CR>")
-- K.Key_mapper("n", "]<C-F>", ":cnfile<CR>")
-- K.Key_mapper("n", "[<C-F>", ":cpfile<CR>")

-- Buffers
-- K.Key_mapper("n", "<BS>", "<C-^>")
-- K.Key_mapper("n", "]b", ":bnext<CR>")
-- K.Key_mapper("n", "[b", ":bprevious<CR>")

-- Args
-- K.Key_mapper("n", "]a", ":next<CR>")
-- K.Key_mapper("n", "[a", ":previous<CR>")

-- Substitute
-- K.Key_mapper("n", "<Bslash>s", ":%s/\\v<<C-r><C-w>>/")

-- Global
-- K.Key_mapper("n", "<Bslash>g", ":g//#<Left><Left>")

-- New lines
-- K.Key_mapper("n", "]<space>", "o<C-c>")
-- K.Key_mapper("n", "[<space>", "O<C-c>")

-- Edit
-- K.Key_mapper("n", "<space>ee", [[:e <C-R>='%:h/'<CR>]])
-- K.Key_mapper("n", "<space>ev", [[:vsp <C-R>='%:h/'<CR>]])
-- K.Key_mapper("n", "<space>es", [[:sp <C-R>='%:h/'<CR>]])
