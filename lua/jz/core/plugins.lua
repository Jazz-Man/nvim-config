-----------------------------------------------------------
-- Plugin manager configuration file
-----------------------------------------------------------
-- Plugin manager: packer.nvim
-- url: https://github.com/wbthomason/packer.nvim
-- Automatically install packer
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') ..
                         '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system(
      {
        'git',
        'clone',
        '--depth',
        '1',
        'https://github.com/wbthomason/packer.nvim',
        install_path
      }
    )
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

-- Use a protected call so we don't error out on first use

-- Install plugins
return require('packer').startup(
         {
    function( use )
      -- speed up 'require', must be the first plugin
      use 'lewis6991/impatient.nvim'

      use 'wbthomason/packer.nvim' -- packer can manage itself

      use 'norcalli/nvim_utils'

      use 'nvim-lua/plenary.nvim'
      use 'nvim-lua/popup.nvim'

      require('jz.modules.lsp')(use)

      require('jz.modules.editor')(use)
      require('jz.modules.tools')(use)
      require('jz.modules.ui')(use)
      require('jz.modules.vcs')(use)

      -- Automatically set up your configuration after cloning packer.nvim
      -- Put this at the end after all plugins
      if packer_bootstrap then require('packer').sync() end
    end,
    config = {
      ensure_dependencies = true,
      autoremove = true,
      display = {
        open_fn = function()
          return require('packer.util').float { border = 'rounded' }
        end
      }
    }
  }
       )
