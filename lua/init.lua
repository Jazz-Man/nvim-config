--- packer.nvim
--- https://github.com/wbthomason/packer.nvim

local com = vim.api.nvim_command

local g = vim.g

local fn = vim.fn
local luv = vim.loop

local packer_path = luv.os_homedir() .. "/.local/share/nvim/site/pack/packer/opt/packer.nvim"

com("packadd packer.nvim")
-- Built in plugins
com("packadd! cfilter")
com("packadd! matchit")

-- Temporary until https://github.com/neovim/neovim/pull/12632 is merged
vim._update_package_paths()

local packer = require("packer")
local packages = require("packages")

packer.startup(
  function()
    for key, value in pairs(packages) do
      packer.use(value)
    end

    -- Temporary until https://github.com/neovim/neovim/pull/12632 is merged
    vim._update_package_paths()
  end
)

-- Diagnostics
g.diagnostic_enable_virtual_text = 1
g.diagnostic_trimmed_virtual_text = 60
g.diagnostic_enable_underline = 1
g.diagnostic_insert_delay = 1
g.diagnostic_virtual_text_prefix = "▢"

-- Dirvish
g.loaded_netrwPlugin = 1
g.dirvish_mode = [[:sort ,^.*[/],]]

-- Fugitive
g.fugitive_pty = 0

-- Mapping
require "mapping"

-- Command
require "command"
