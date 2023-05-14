return {
  {
    'nvim-treesitter/nvim-treesitter',
    version = false, -- last release is way too old and doesn't work on Windows
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter-textobjects' },
      'nvim-treesitter/nvim-treesitter-refactor',
      'JoosepAlviste/nvim-ts-context-commentstring'
    },
    ---@type TSConfig
    opts = {
      ensure_installed = 'all',
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true, -- false will disable the whole extension
        additional_vim_regex_highlighting = false,
        disable = { 'help' }
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          -- mappings for incremental selection (visual mappings)
          init_selection = '<CR>', -- maps in normal mode to init the node/scope selection
          scope_incremental = '<Tab>', -- increment to the upper scope (as defined in locals.scm)
          node_incremental = '<CR>', -- increment to the upper named parent
          node_decremental = '<S-Tab>' -- decrement to the previous node
        }
      },
      indent = { enable = true },
      refactor = {
        highlight_defintions = { enable = true, clear_on_cursor_move = true },
        highlight_current_scope = {
          enable = false -- Breaks virtual text
        },
        smart_rename = {
          enable = true,
          keymaps = { smart_rename = '<leader>gr' }
        },
        navigation = {
          enable = true,
          keymaps = {
            goto_definition = 'gnd', -- mapping togo to definition of symbol under cursor
            list_definitions = 'gnD', -- mapping to list all definitions in current file
            goto_next_usage = '<c-n>',
            goto_previous_usage = '<c-p>'
          }
        }
      },
      context_commentstring = { enable = true },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner'
          }
        },
        swap = {
          enable = true,
          swap_next = { ['<leader>a'] = '@parameter.inner' },
          swap_previous = { ['<leader>A'] = '@parameter.inner' }
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            [']m'] = '@function.outer',
            [']]'] = '@class.outer'
          },
          goto_next_end = { [']M'] = '@function.outer', [']['] = '@class.outer' },
          goto_previous_start = {
            ['[m'] = '@function.outer',
            ['[['] = '@class.outer'
          },
          goto_previous_end = {
            ['[M'] = '@function.outer',
            ['[]'] = '@class.outer'
          }
        },
        lsp_interop = { enable = true, border = 'single' }
      },
      playground = { enable = true },
      autopairs = { enable = true }
    },
    ---@param opts TSConfig
    config = function( _, opts )
      local treesitter = require 'nvim-treesitter'
      local query = require 'nvim-treesitter.query'

      local foldmethod_backups = {}
      local foldexpr_backups = {}

      treesitter.define_modules(
        {
          folding = {
            enable = true,
            attach = function( bufnr )
              -- Fold settings are actually window based...
              foldmethod_backups[bufnr] = vim.wo.foldmethod
              foldexpr_backups[bufnr] = vim.wo.foldexpr
              vim.wo.foldmethod = 'expr'
              vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
            end,
            detach = function( bufnr )
              vim.wo.foldmethod = foldmethod_backups[bufnr]
              vim.wo.foldexpr = foldexpr_backups[bufnr]
              foldmethod_backups[bufnr] = nil
              foldexpr_backups[bufnr] = nil
            end,
            is_supported = query.has_folds
          }
        }
      )

      require('nvim-treesitter.configs').setup(opts)
    end
  },
  {
    'windwp/nvim-ts-autotag',
    config = function( _, opts ) require('nvim-ts-autotag').setup(opts) end
  }
}
