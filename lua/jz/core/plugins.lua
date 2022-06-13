-----------------------------------------------------------
-- Plugin manager configuration file
-----------------------------------------------------------
-- Plugin manager: packer.nvim
-- url: https://github.com/wbthomason/packer.nvim
-- Automatically install packer
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system(

                         {
          'git',
          'clone',
          '--depth',
          '1',
          'https://github.com/wbthomason/packer.nvim',
          install_path
      }
                       )
    print 'Installing packer close and reopen Neovim...'
    vim.cmd [[packadd packer.nvim]]
end

-- Use a protected call so we don't error out on first use

local packer = require('packer')
--
-- Have packer use a popup window

packer.init {
    ensure_dependencies = true,
    display = {
        open_fn = function()
            return require('packer.util').float {border = 'rounded'}
        end
    },
    autoremove = true
}

-- Install plugins
return packer.startup(
         function( use )
      -- speed up 'require', must be the first plugin
      use {'lewis6991/impatient.nvim'}

      use {'wbthomason/packer.nvim'} -- packer can manage itself

      use 'norcalli/nvim_utils'

      use 'nvim-lua/plenary.nvim'
      use 'nvim-lua/popup.nvim'

      for _, modules in ipairs(require('jz.modules')) do modules(use) end

      -- Automatically set up your configuration after cloning packer.nvim
      -- Put this at the end after all plugins
      if PACKER_BOOTSTRAP then require('packer').sync() end
  end
       )
