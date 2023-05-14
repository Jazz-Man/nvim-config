local autocmds = vim.api.nvim_create_autocmd
local utils = require 'jz.utils'
local icons = require 'jz.config.icons'

return {

  { 'nvim-tree/nvim-web-devicons', lazy = true, opts = { default = true } },
  'NvChad/nvim-colorizer.lua',
  {
    'SmiteshP/nvim-navic',
    lazy = true,
    init = function()
      vim.g.navic_silence = true

      utils.on_attach(
        function( client, buffer )
          if client.server_capabilities.documentSymbolProvider then
            require('nvim-navic').attach(client, buffer)

          end

        end
      )

    end,
    opts = {

      separator = ' ',
      highlight = true,
      depth_limit = 5,
      icons = icons.kinds

    }
  },

  -- better vim.ui
  {
    'stevearc/dressing.nvim',
    lazy = true,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function( ... )
        require('lazy').load({ plugins = { 'dressing.nvim' } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function( ... )
        require('lazy').load({ plugins = { 'dressing.nvim' } })
        return vim.ui.input(...)
      end
    end
  },

  -- bufferline
  {
    'akinsho/bufferline.nvim',
    event = 'VeryLazy',
    init = function() vim.opt.termguicolors = true end,
    opts = {
      options = {
        offsets = {
          {
            filetype = 'neo-tree',
            text = 'Neo-tree',
            highlight = 'Directory',
            text_align = 'left'
          }
        },
        max_name_length = 14,
        max_prefix_length = 13,
        tab_size = 20,
        show_tab_indicators = true,
        show_buffer_icons = true,
        enforce_regular_tabs = false,
        view = 'multiwindow',
        show_buffer_close_icons = true,
        separator_style = 'thin',
        always_show_bufferline = true,
        diagnostics = false,
        themable = true,
        numbers = 'buffer_id',
        groups = {

          options = {
            toggle_hidden_on_enter = true -- when you re-enter a hidden group this options re-opens that group so the buffer is visible
          },
          items = {
            {
              name = 'tests', -- Mandatory
              matcher = function( buf ) -- Mandatory
                return buf.name:match('%_test') or buf.name:match('%_spec')
              end
            },
            {
              name = 'docs',
              auto_close = false, -- whether or not close this group if it doesn't contain the current buffer
              matcher = function( buf )
                return buf.name:match('%.md') or buf.name:match('%.txt')
              end
            }
          }
        }
      }
    }
  },

  {
    'lukas-reineke/indent-blankline.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    config = {
      char = '▏',
      filetype_exclude = {
        'help',
        'alpha',
        'dashboard',
        'neo-tree',
        'Trouble',
        'lazy'
      },
      show_trailing_blankline_indent = false,
      show_current_context = false
    }
  },
  {
    'echasnovski/mini.indentscope',
    version = false, -- wait till new 0.7.0 release to put it back on semver
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      -- symbol = "▏",
      symbol = '│',
      options = { try_as_border = true }
    },
    init = function()
      autocmds(
        'FileType', {
          pattern = {
            'help',
            'alpha',
            'dashboard',
            'neo-tree',
            'Trouble',
            'lazy',
            'mason'
          },
          callback = function() vim.b.miniindentscope_disable = true end
        }
      )
    end,
    config = function( _, opts ) require('mini.indentscope').setup(opts) end

  },

  {
    'rcarriga/nvim-notify',
    opts = {
      timeout = 3000,
      max_height = function() return math.floor(vim.o.lines * 0.75) end,
      max_width = function() return math.floor(vim.o.columns * 0.75) end
    },
    keys = {
      {
        '<leader>un',
        function()
          require('notify').dismiss({ silent = true, pending = true })
        end,
        desc = 'Delete all Notifications'
      }
    },
    init = function()

      if not utils.has('noice.nvim') then
        utils.on_very_lazy(function() vim.notify = require('notify') end)

      end
    end
  },
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    opts = function()

      return {
        options = {
          theme = 'auto',
          globalstatus = true,
          disabled_filetypes = { statusline = { 'dashboard', 'alpha' } }
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = {
            {
              'filetype',
              icon_only = true,
              separator = '',
              padding = { left = 1, right = 0 }
            },
            { 'fileformat', separator = '', padding = { left = 1, right = 0 } },
            { 'encoding' },
            { 'filename', path = 1 },
            {
              function()
                return require('nvim-navic').get_location()
              end,
              cond = function()
                return package.loaded['nvim-navic'] and
                         require('nvim-navic').is_available()
              end
            }
          },
          lualine_x = {
            -- stylua: ignore
            {
              function() return '  ' .. require('dap').status() end,
              cond = function()
                return package.loaded['dap'] and require('dap').status() ~= ''
              end,
              color = utils.fg('Debug')
            },
            {
              require('lazy.status').updates,
              cond = require('lazy.status').has_updates,
              color = utils.fg('Special')
            }

          },
          lualine_y = {
            { 'progress', separator = ' ', padding = { left = 1, right = 0 } },
            { 'location', padding = { left = 0, right = 1 } }
          },
          lualine_z = { { 'datetime', style = '%R' } }
        },
        extensions = { 'neo-tree', 'lazy', 'symbols-outline' }
      }

    end
  },
  -- ui components
  { 'MunifTanjim/nui.nvim', lazy = true }

}
