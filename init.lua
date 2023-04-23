-- Leader/local leader - lazy.nvim needs these set first
vim.g.mapleader = [[ ]]
vim.g.maplocalleader = [[,]]
vim.g.termguicolors = true


local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    '--single-branch',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  }
end

vim.opt.runtimepath:prepend(lazypath)

vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

require("lazy").setup('plugins',{
  defaults = { lazy = true },
  performance = {
    rtp = {
      disabled_plugins = {
        '2html_plugin',
        'getscript',
        'getscriptPlugin',
        'gzip',
        'logipat',
        'matchit',
        -- 'netrw',
        -- 'netrwFileHandlers',
        'loaded_remote_plugins',
        'loaded_tutor_mode_plugin',
        -- 'netrwPlugin',
        -- 'netrwSettings',
        'rrhelper',
        'spellfile_plugin',
        'tar',
        'tarPlugin',
  'vimball',
  'vimballPlugin',
  'zip',
  'zipPlugin',
      }
    }
  }
})


--- TODO https://www.vi-improved.org/vim-tips/
-- require('jz.utils.logger').init(vim.log.levels.WARN)

local present, impatient = pcall(require, 'impatient')

if present then
  impatient.enable_profile()
else
  vim.notify(impatient)
end

-- require 'jz.globals'
require 'jz.core'
