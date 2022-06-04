local present, impatient = pcall(require, 'impatient')

if present then
  impatient.enable_profile()
else
  vim.notify(impatient)
end

require 'jz.globals'
require 'jz.core'
