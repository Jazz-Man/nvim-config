local utils = require 'jz.utils'

local opt_local = vim.opt_local

local autocmd = {

  no_cursorline_in_insert_mode = {
    {
      event = { 'InsertLeave', 'WinEnter', 'BufEnter' },
      options = { callback = function() opt_local.cursorline = true end }
    },
    {
      event = { 'InsertEnter', 'WinLeave', 'BufLeave' },
      options = { callback = function() opt_local.cursorline = false end }
    }
  },

  buffer_mappings = {
    {
      event = 'FileType',
      options = {
        pattern = {
          'qf',
          'help',
          'man',
          'floaterm',
          'lspinfo',
          'lsp-installer',
          'null-ls-info'
        },
        command = 'nnoremap <silent> <buffer> q :close<CR>'
      }
    }
  },
  disable_undo = {
    {
      event = 'BufWritePre',
      options = {
        pattern = { '/tmp/*', 'COMMIT_EDITMSG', 'MERGE_MSG', '*.tmp', '*bak' },
        callback = function() opt_local.undofile = false end
      }
    }
  },
  auto_resize = {
    {
      event = 'VimResized',
      options = { pattern = '*', command = 'tabdo wincmd =' }
    }
  },
  terminal_settings = {
    {
      event = 'TermOpen',
      options = {
        callback = function()
          opt_local.bufhidden = 'hide'
          opt_local.number = false
        end
      }
    },
    { event = 'CmdLineEnter', options = { command = 'set nosmartcase' } },
    { event = 'CmdLineLeave', options = { command = 'set smartcase' } },
    {
      event = 'CmdlineEnter',
      options = { pattern = '/,\\?', command = ':set hlsearch' }
    },
    {
      event = 'CmdlineLeave',
      options = { pattern = '/,\\?', command = ':set nohlsearch' }
    }
  },
  packer_user_config = {
    -- Autocommand that reloads neovim whenever you save the packer_init.lua file
    {
      event = 'BufWritePost',
      options = {
        pattern = 'packer_init.lua',
        command = 'source <afile> | PackerSync'
      }
    },
    {
      event = 'BufWritePost',
      options = {
        pattern = { '$VIM_PATH/**', '!packer_init.lua' },
        command = 'source $MYVIMRC | redraw',
        nested = true
      }
    }
  },
  yank = {
    {
      event = 'TextYankPost',
      options = {
        callback = function() vim.highlight.on_yank({ timeout = 100 }) end,
        pattern = '*'

      }
    }
  }
}

utils.autocommand(autocmd)
