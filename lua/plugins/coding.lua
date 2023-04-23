return {
  {
    'ms-jpq/coq_nvim',
    branch = 'coq',
    lazy = false,
    build = ':COQdeps',
    init = function()
      vim.g.coq_settings = {
        auto_start = true,
        xdg = true,
        display = { ghost_text = { enabled = true }, icons = { mode = 'long' } },
        completion = { always = true, skip_after = { '{', '}', '[', ']' } },
        clients = {
          buffers = { match_syms = true, same_filetype = true },
          tmux = { match_syms = true, all_sessions = true }
          -- tabnine = true
        }
      }
    end,
    dependencies = {
      { 'ms-jpq/coq.artifacts', branch = 'artifacts' },
      {
        'ms-jpq/coq.thirdparty',
        branch = '3p',
        config = function( _, opts )
          require('coq_3p') {
            { src = 'nvimlua', short_name = 'nLUA' },
            { src = 'vimtex', short_name = 'vTEX' },
            { src = 'bc', short_name = 'MATH', precision = 6 }
          }
        end
      }
    }
  },
  -- auto pairs
  {
    'echasnovski/mini.pairs',
    event = 'VeryLazy',
    version = false,
    config = function( _, opts ) require('mini.pairs').setup(opts) end
  },
  {
    'echasnovski/mini.surround',
    version = false,
    keys = function( _, keys )
      -- Populate the keys based on the user's options
      local plugin = require('lazy.core.config').spec.plugins['mini.surround']
      local opts = require('lazy.core.plugin').values(plugin, 'opts', false)
      local mappings = {
        { opts.mappings.add, desc = 'Add surrounding', mode = { 'n', 'v' } },
        { opts.mappings.delete, desc = 'Delete surrounding' },
        { opts.mappings.find, desc = 'Find right surrounding' },
        { opts.mappings.find_left, desc = 'Find left surrounding' },
        { opts.mappings.highlight, desc = 'Highlight surrounding' },
        { opts.mappings.replace, desc = 'Replace surrounding' },
        {
          opts.mappings.update_n_lines,
          desc = 'Update `MiniSurround.config.n_lines`'
        }
      }
      mappings = vim.tbl_filter(
                   function( m ) return m[1] and #m[1] > 0 end, mappings
                 )
      return vim.list_extend(mappings, keys)
    end,
    opts = {
      mappings = {
        add = 'gza', -- Add surrounding in Normal and Visual modes
        delete = 'gzd', -- Delete surrounding
        find = 'gzf', -- Find surrounding (to the right)
        find_left = 'gzF', -- Find surrounding (to the left)
        highlight = 'gzh', -- Highlight surrounding
        replace = 'gzr', -- Replace surrounding
        update_n_lines = 'gzn' -- Update `n_lines`
      }
    },
    config = function( _, opts )
      -- use gz mappings instead of s to prevent conflict with leap
      require('mini.surround').setup(opts)
    end
  },
  -- comments
  { 'JoosepAlviste/nvim-ts-context-commentstring', lazy = true },
  {
    'echasnovski/mini.comment',
    event = 'VeryLazy',
    opts = {
      hooks = {
        pre = function()
          require('ts_context_commentstring.internal').update_commentstring({})
        end
      }
    },
    config = function( _, opts ) require('mini.comment').setup(opts) end
  }
}
