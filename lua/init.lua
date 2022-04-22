local global = require "utils/global"
local A = require "utils/general"

local options = require "options"
local com = vim.api.nvim_command

local g = vim.g

-- Built in plugins
com("packadd! cfilter")
-- com("packadd! menu.vim")

vim.cmd [[packadd packer.nvim]]

local M = {}

function M.createdir()
    local data_dir = {
        global.cache_dir .. "backup", global.cache_dir .. "session",
        global.cache_dir .. "swap", global.cache_dir .. "tags",
        global.cache_dir .. "undo", global.snippet_dir, global.template_dir
    }
    if not global.isdir(global.cache_dir) then
        os.execute("mkdir -p " .. global.cache_dir)
    end
    for _, v in pairs(data_dir) do
        if not global.isdir(v) then os.execute("mkdir -p " .. v) end
    end
end

function M.leader_map()
    g.mapleader = " "
    A.Key_mapper("n", " ", "")
    A.Key_mapper("x", " ", "")
end

function M.disable_distribution_plugins()
    g.loaded_gzip = 1
    g.loaded_tar = 1
    g.loaded_tarPlugin = 1
    g.loaded_zip = 1
    g.loaded_zipPlugin = 1
    g.loaded_getscript = 1
    g.loaded_getscriptPlugin = 1
    g.loaded_vimball = 1
    g.loaded_vimballPlugin = 1
    g.loaded_matchit = 1
    g.loaded_matchparen = 1
    g.loaded_2html_plugin = 1
    g.loaded_logiPat = 1
    g.loaded_rrhelper = 1
    g.loaded_netrw = 1
    g.loaded_netrwPlugin = 1
    g.loaded_netrwSettings = 1
    g.loaded_netrwFileHandlers = 1
end

function M.locad_core()
    M.createdir()
    M.disable_distribution_plugins()
    --  M.leader_map()

    options:load_options()
    local packer = require("packer")
    local packages = require("packages")

    packer.startup(function(use)
        for key, value in pairs(packages) do use(value) end
    end)
end

-- Fugitive
g.fugitive_pty = 0

M.locad_core()

-- Mapping
-- require "mapping"

-- Command

-- require "autocmd"
