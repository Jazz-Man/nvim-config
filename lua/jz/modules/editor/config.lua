local config = {}

config.comment = function()

  require('Comment').setup {
    padding = true, -- Add a space b/w comment and the line
    sticky = true, -- Whether the cursor should stay at its position
    ignore = '^$',
    mapping = { basic = false, extra = false, extended = false }
  }

end

config.treesitter = function()

  local treesitter = require 'nvim-treesitter'
  local query = require 'nvim-treesitter.query'

  local foldmethod_backups = {}
  local foldexpr_backups = {}

  treesitter.define_modules(
    {
      folding = {
        enable = true,
        attach = function(bufnr)
          -- Fold settings are actually window based...
          foldmethod_backups[bufnr] = vim.wo.foldmethod
          foldexpr_backups[bufnr] = vim.wo.foldexpr
          vim.wo.foldmethod = 'expr'
          vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
        end,
        detach = function(bufnr)
          vim.wo.foldmethod = foldmethod_backups[bufnr]
          vim.wo.foldexpr = foldexpr_backups[bufnr]
          foldmethod_backups[bufnr] = nil
          foldexpr_backups[bufnr] = nil
        end,
        is_supported = query.has_folds
      }
    }
  )

  require 'nvim-treesitter.configs'.setup {
    ensure_installed = 'all',
    sync_install = false,
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
      smart_rename = { enable = true, keymaps = { smart_rename = '<leader>gr' } },
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
        goto_next_start = { [']m'] = '@function.outer', [']]'] = '@class.outer' },
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
  }

end

config.ts_autotag = function() require('nvim-ts-autotag').setup({}) end

config.nvim_gomove = function()
  require('gomove').setup {
    -- whether or not to map default key bindings, (true/false)
    map_defaults = false
    -- whether or not to reindent lines moved vertically (true/false)
    -- reindent = true,
    -- whether or not to undojoin same direction moves (true/false)
    -- undojoin = true,
    -- whether to not to move past end column when moving blocks horizontally, (true/false)
    -- move_past_end_col = false,
  }
end

config.vim_mundo = function()

  vim.g.undotree_DiffAutoOpen = 1
  vim.g.undotree_SetFocusWhenToggle = 1
  vim.g.undotree_WindowLayout = 4
  vim.g.undotree_DiffpanelHeight = 40
  -- vim.g.mundo_right = 1
  -- vim.g.mundo_width = 60
  -- vim.g.mundo_preview_height = 40
  -- vim.g.mundo_help = 1
  -- vim.g.mundo_preview_bottom = 1
end

config.blankline = function()

  require('indent_blankline').setup(
    {
      indentLine_enabled = 1,
      char = '▏',
      filetype_exclude = {
        'help',
        'terminal',
        'alpha',
        'packer',
        'lspinfo',
        'TelescopePrompt',
        'TelescopeResults',
        'nvchad_cheatsheet',
        'lsp-installer',
        ''
      },
      buftype_exclude = { 'terminal' },
      show_trailing_blankline_indent = false,
      show_first_indent_level = false,
      show_current_context = true
    }
  )
end
config.refactoring = function() require('refactoring').setup({}) end

return config
