local conf = {}

conf.neogit = function()

  require('neogit').setup {
    disable_signs = true,
    disable_context_highlighting = false,
    disable_commit_confirmation = false,
    integrations = { diffview = true }
  }

end

conf.gitsigns = function()

  require('gitsigns').setup {
    signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
    numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
    linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
    current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
    on_attach = function( bufnr )
      local gs = package.loaded.gitsigns

      local function map( mode, l, r, opts )
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map(
        'n', ']c', function()
          if vim.wo.diff then return ']c' end
          vim.schedule(function() gs.next_hunk() end)
          return '<Ignore>'
        end, { expr = true }
      )

      map(
        'n', '[c', function()
          if vim.wo.diff then return '[c' end
          vim.schedule(function() gs.prev_hunk() end)
          return '<Ignore>'
        end, { expr = true }
      )

      -- Actions
      map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>')
      map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>')
      map('n', '<leader>hS', gs.stage_buffer)
      map('n', '<leader>hu', gs.undo_stage_hunk)
      map('n', '<leader>hR', gs.reset_buffer)
      map('n', '<leader>hp', gs.preview_hunk)
      map('n', '<leader>hb', function() gs.blame_line { full = true } end)
      map('n', '<leader>tb', gs.toggle_current_line_blame)
      map('n', '<leader>hd', gs.diffthis)
      map('n', '<leader>hD', function() gs.diffthis('~') end)
      map('n', '<leader>td', gs.toggle_deleted)

      -- Text object
      map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
    end
  }

end

conf.diffview = function()

  require('diffview').setup {
    diff_binaries = false, -- Show diffs for binaries
    enhanced_diff_hl = true, -- See ':h diffview-config-enhanced_diff_hl'
    use_icons = true, -- Requires nvim-web-devicons
    file_panel = {
      listing_style = 'tree', -- One of 'list' or 'tree'
      tree_options = { -- Only applies when listing_style is 'tree'
        flatten_dirs = true, -- Flatten dirs that only contain one single dir
        folder_statuses = 'only_folded' -- One of 'never', 'only_folded' or 'always'.
      },
      win_config = { -- See ':h diffview-config-win_config'
        position = 'left',
        width = 35
      }
    },
    file_history_panel = {
      log_options = { -- See ':h diffview-config-log_options'
        single_file = {
          diff_merges = 'combined',
          follow = true,
          show_pulls = true,
          reflog = true,
          all = true
        },
        multi_file = { diff_merges = 'first-parent' }
      },
      win_config = { -- See ':h diffview-config-win_config'
        position = 'bottom',
        height = 16,
        type = 'split'
      }
    },
    commit_log_panel = {
      win_config = {} -- See ':h diffview-config-win_config'
    },
    default_args = { -- Default args prepended to the arg-list for the listed commands
      DiffviewOpen = {},
      DiffviewFileHistory = {}
    }
  }

end

return conf
