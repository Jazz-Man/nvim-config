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
      -- use { "lewis6991/impatient.nvim" }

      use {'wbthomason/packer.nvim'} -- packer can manage itself

      -- Analyze startuptime
      use {'dstein64/vim-startuptime', cmd = 'StartupTime'}

      use 'norcalli/nvim_utils'

      use 'tjdevries/lazy.nvim'

    --   use 'nathom/filetype.nvim'

      use({'nvim-lua/plenary.nvim'})

      use({'nvim-lua/popup.nvim'})

      use 'NvChad/nvterm'

      use {
          'numToStr/Comment.nvim',
          module = 'Comment',
          config = 'require (\'jz.config.comment\')',
          keys = {'gc', 'gl'}
      }

    --   use {'rmagatti/auto-session', config = 'require(\'jz.config.sessions\')'}

      for _, modules in ipairs(require('jz.modules')) do
            modules(use)
    end

      --- EDITOR Start
      use {
          'mg979/vim-visual-multi',
          keys = {
              '<Ctrl>',
              '<M>',
              '<C-n>',
              '<C-n>',
              '<M-n>',
              '<S-Down>',
              '<S-Up>',
              '<M-Left>',
              '<M-i>',
              '<M-Right>',
              '<M-D>',
              '<M-Down>',
              '<C-d>',
              '<C-Down>',
              '<S-Right>',
              '<C-LeftMouse>',
              '<M-LeftMouse>',
              '<M-C-RightMouse>',
              '<Leader>'
          },
          config = function()
              vim.g.VM_mouse_mappings = 1
              vim.g.VM_silent_exit = 1
              vim.g.VM_show_warnings = 0
              vim.g.VM_default_mappings = 1
              vim.cmd(
                [[
        let g:VM_maps = {}
        let g:VM_maps['Find Under'] = '<C-n>'
        let g:VM_maps['Find Subword Under'] = '<C-n>'
        let g:VM_maps['Select All'] = '<C-M-n>'
        let g:VM_maps['Seek Next'] = 'n'
        let g:VM_maps['Seek Prev'] = 'N'
        let g:VM_maps["Undo"] = 'u'
        let g:VM_maps["Redo"] = '<C-r>'
        let g:VM_maps["Remove Region"] = '<cr>'
        let g:VM_maps["Add Cursor Down"] = '<M-Down>'
        let g:VM_maps["Add Cursor Up"] = "<M-Up>"
        let g:VM_maps["Mouse Cursor"] = "<M-LeftMouse>"
        let g:VM_maps["Mouse Word"] = "<M-RightMouse>"
        let g:VM_maps["Add Cursor At Pos"] = '<M-i>'
    ]]
              )
          end
      }

      use {'tpope/vim-surround', event = 'InsertEnter'}

      use {
          'lukas-reineke/indent-blankline.nvim',
          event = 'BufRead',
          config = 'require(\'jz.config.blankline\')'
      }

      use {
          'booperlv/nvim-gomove',
          event = {'CursorMoved', 'CursorMovedI'},
          config = function() require('gomove').setup({}) end
      }

      use {
          'simnalamburt/vim-mundo',
          opt = true,
          cmd = {'MundoToggle', 'MundoShow', 'MundoHide'}
      }
      --- EDITOR End

      --- Language Start

      use {
          'crispgm/nvim-go',
          config = 'require (\'jz.config.go\')',
          ft = {'go', 'gomod'}
      }

      use {'nanotee/sqls.nvim', ft = {'sql', 'pgsql'}}

      use {'folke/lua-dev.nvim', ft = {'lua'}}

      use {
          'jose-elias-alvarez/nvim-lsp-ts-utils',
          ft = {'typescriptreact', 'typescript'}

      }

      --- Language End

      --- LSP Start

      use {
          'kristijanhusak/vim-dadbod-completion',
          event = 'InsertEnter',
          ft = {'sql'},
          setup = function()
              vim.cmd(
                [[autocmd FileType sql setlocal omnifunc=vim_dadbod_completion#omni]]
              )
          end
      }

      use {
          'neovim/nvim-lspconfig',
          event = 'BufRead',
          config = 'require(\'jz.lsp\')',
          requires = {
              {'williamboman/nvim-lsp-installer', after = 'nvim-lspconfig'},
              {'jose-elias-alvarez/null-ls.nvim', after = 'nvim-lspconfig'},
              {'ray-x/lsp_signature.nvim', after = 'nvim-lspconfig'}
          }
      }

      use {
          'L3MON4D3/LuaSnip',
          config = 'require(\'jz.config.luasnip\')',
          event = 'InsertEnter',
          requires = {{'rafamadriz/friendly-snippets', event = 'InsertEnter'}}
      }

      use {
          'hrsh7th/nvim-cmp',
          config = 'require(\'jz.config.cmp\')',
          after = {'LuaSnip'},
          -- The completion plugin
          requires = {
              {'hrsh7th/cmp-buffer', after = 'nvim-cmp', opt = true},
              {'hrsh7th/cmp-path', after = 'nvim-cmp', opt = true},
              {'saadparwaiz1/cmp_luasnip', after = {'nvim-cmp', 'LuaSnip'}},
              {'hrsh7th/cmp-nvim-lsp', after = 'nvim-cmp', opt = true},
              {'hrsh7th/cmp-nvim-lua', after = 'nvim-cmp', ft = {'lua'}},
              {'hrsh7th/cmp-nvim-lsp-document-symbol', after = 'nvim-cmp', opt = true},
              {'hrsh7th/cmp-nvim-lsp-signature-help', after = 'nvim-cmp', opt = true},
              {'hrsh7th/cmp-omni', after = 'nvim-cmp', opt = true},
              {'ray-x/cmp-treesitter', after = 'nvim-cmp', opt = true},
              {'windwp/nvim-autopairs', after = 'nvim-cmp', opt = true}
          }
      }

      use {
          'nvim-telescope/telescope.nvim',
          -- opt = true,
          setup = 'require (\'jz.telescope.mappings\')',
          config = 'require (\'jz.telescope\')',
          -- cmd = "Telescope",
          requires = {
              'nvim-lua/popup.nvim',
              'nvim-lua/plenary.nvim',
              'nvim-telescope/telescope-packer.nvim',
              'nvim-telescope/telescope-ui-select.nvim',
              {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'}
          }
      }
      --- LSP End

      use {
          'nvim-treesitter/nvim-treesitter',
          config = 'require(\'jz.config.treesitter\')',
          run = ':TSUpdate',
          event = {'BufRead', 'BufNewFile'},
          requires = {
              {
                  'nvim-treesitter/nvim-treesitter-refactor',
                  after = {'nvim-treesitter'}
              },
              {
                  'nvim-treesitter/nvim-treesitter-textobjects',
                  after = {'nvim-treesitter'}
              },
              {
                  'JoosepAlviste/nvim-ts-context-commentstring',
                  after = {'nvim-treesitter'}
              },
              {'windwp/nvim-ts-autotag', after = {'nvim-treesitter'}}
          }
      }

      use {
          'ThePrimeagen/refactoring.nvim',
          setup = 'require (\'jz.config.refactoring.mappings\')',
          config = 'require(\'jz.config.refactoring\')',
          require = {'nvim-lua/plenary.nvim', 'nvim-treesitter/nvim-treesitter'},
          after = {'nvim-treesitter'}
      }

      -- Automatically set up your configuration after cloning packer.nvim
      -- Put this at the end after all plugins
      if PACKER_BOOTSTRAP then require('packer').sync() end
  end
       )
