--- TODO https://www.vi-improved.org/vim-tips/
require('jz.utils.logger').init(vim.log.levels.WARN)

local present, impatient = pcall(require, 'impatient')

if present then
  impatient.enable_profile()
else
  vim.notify(impatient)
end

require 'jz.globals'
require 'jz.core'
