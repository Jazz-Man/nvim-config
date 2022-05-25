local present, impatient = pcall(require, "impatient")

if present then
   impatient.enable_profile()
end


require 'jz.globals'
require 'jz.options'

require 'jz.packer_init'
