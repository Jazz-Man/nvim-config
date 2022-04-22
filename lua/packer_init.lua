-----------------------------------------------------------
-- Plugin manager configuration file
-----------------------------------------------------------
-- Plugin manager: packer.nvim
-- url: https://github.com/wbthomason/packer.nvim
-- Automatically install packer
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

local packages = require("packages")

if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({
        'git', 'clone', '--depth', '1',
        'https://github.com/wbthomason/packer.nvim', install_path
    })
end

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, 'packer')
if not status_ok then return end

local packer_utils_ok, packer_utils = pcall(require, "packer.util")
if not packer_utils_ok then return end



-- Have packer use a popup window
packer.init {
  ensure_dependencies = true,  
  display = {
        open_fn = function()
            return packer_utils.float {border = "rounded"}
        end
    },
    autoremove = true
}

-- Install plugins
return packer.startup(function(use)
    -- Add you plugins here:
    use 'wbthomason/packer.nvim' -- packer can manage itself
    use 'norcalli/nvim_utils'
    use {"sainnhe/sonokai", config = "require [[config/theme]]"}

    -- Icons
    use 'kyazdani42/nvim-web-devicons'

    use {
        "norcalli/nvim-colorizer.lua",
        config = "require [[config/colorizer]]",
        opt = true,
        cmd = {
            "ColorizerDetachFromBuffer", "ColorizerReloadAllBuffers",
            "ColorizerToggle"
        }
    }

    -- Statusline
    use {'nvim-lualine/lualine.nvim', config = "require [[config/statusline]]"}

    use {
        "folke/which-key.nvim",
        config = "require [[config/which-key]]",
        cmd = {"WhichKey"}
    }

    -- File explorer
    use {
        'kyazdani42/nvim-tree.lua',
        config = "require [[config/nvim-tree]]",
        cmd = {
            "NvimTreeToggle", "NvimTreeRefresh", "NvimTreeFindFile",
            "NvimTreeOpen", "NvimTreeClose", "NvimTreeFocus",
            "NvimTreeFindFileToggle", "NvimTreeResize", "NvimTreeCollapse",
            "NvimTreeCollapseKeepBuffers"
        }
    }

    use {
        'nvim-telescope/telescope.nvim',
        config = "require [[config/telescope]]",
        cms = {"Telescope"},
        requires = {'nvim-lua/plenary.nvim'}
    }

    use {"RishabhRD/nvim-lsputils", requires = {"RishabhRD/popfix"}}

    use {"nvim-treesitter/nvim-treesitter", run = ':TSUpdate'}

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then require('packer').sync() end
end)
