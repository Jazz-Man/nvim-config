local m = require'jz.utils.keybinding'.map
local c = require'jz.utils.keybinding'.cmd

return {
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },

    opts = {
      signs = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '' },
        topdelete = { text = '' },
        changedelete = { text = '▎' },
        untracked = { text = '▎' }
      },
      on_attach = function( bufnr )
        local gs = package.loaded.gitsigns

        m:group(
          { desc = 'GitSigns', bufnr = bufnr }, function()

            m:nmap():desc('Next Hunk'):k(']h'):c(gs.next_hunk)
            m:nmap():desc('Prev Hunk'):k('[h'):c(gs.prev_hunk)

            m:mode({ 'o', 'x' }):desc('Select Hunk'):k('ih'):c(
              c:cu(
                'Gitsigns select_hunk'
              )
            )

          end
        )

        m:group(
          { desc = 'GitSigns', prefix = '<leader>', bufnr = bufnr }, function()

            m:mode({ 'n', 'v' }):desc('Stage Hunk'):k('ghs'):c(
              c:cmd(
                'Gitsigns stage_hunk'
              )
            )
            m:mode({ 'n', 'v' }):desc('Reset Hunk'):k('ghr'):c(
              c:cmd(
                'Gitsigns reset_hunk'
              )
            )

            m:nmap():desc('Stage Buffer'):k('ghS'):c(gs.stage_buffer)
            m:nmap():desc('Undo Stage Hunk'):k('ghu'):c(gs.undo_stage_hunk)
            m:nmap():desc('Reset Buffer'):k('ghR'):c(gs.reset_buffer)
            m:nmap():desc('Preview Hunk'):k('ghp'):c(gs.preview_hunk)

            m:nmap():desc('Blame Line'):k('ghb'):c(
              function() gs.blame_line({ full = true }) end
            )

            m:nmap():desc('Diff This'):k('ghd'):c(gs.diffthis)

            m:nmap():desc('Diff This ~'):k('ghD'):c(
              function() gs.diffthis('~') end
            )

          end
        )
      end
    }
  },
  {
    'sindrets/diffview.nvim',
    dependencies = 'nvim-lua/plenary.nvim',
    lazy = true ,
    -- cmd = {
    --   'DiffviewOpen',
    --   'DiffviewFileHistory',
    --   'DiffviewFocusFiles',
    --   'DiffviewToggleFiles',

    --   'DiffviewRefresh'
    -- },
    -- opts = {
    --   diff_binaries = false, -- Show diffs for binaries
    --   enhanced_diff_hl = true, -- See ':h diffview-config-enhanced_diff_hl'
    --   use_icons = true, -- Requires nvim-web-devicons
    --   file_panel = {
    --     listing_style = 'tree', -- One of 'list' or 'tree'
    --     tree_options = { -- Only applies when listing_style is 'tree'
    --       flatten_dirs = true, -- Flatten dirs that only contain one single dir
    --       folder_statuses = 'only_folded' -- One of 'never', 'only_folded' or 'always'.
    --     },
    --     win_config = { -- See ':h diffview-config-win_config'
    --       position = 'left',
    --       width = 35
    --     }
    --   },
    --   file_history_panel = {
    --     log_options = { -- See ':h diffview-config-log_options'
    --       single_file = {
    --         diff_merges = 'combined',
    --         follow = true,
    --         show_pulls = true,
    --         reflog = true,
    --         all = true
    --       },
    --       multi_file = { diff_merges = 'first-parent' }
    --     },
    --     win_config = { -- See ':h diffview-config-win_config'
    --       position = 'bottom',
    --       height = 16,
    --       type = 'split'
    --     }
    --   },
    --   commit_log_panel = {
    --     win_config = {} -- See ':h diffview-config-win_config'
    --   },
    --   default_args = { -- Default args prepended to the arg-list for the listed commands
    --     DiffviewOpen = {},
    --     DiffviewFileHistory = {}
    --   }
    -- },
    config = function( _, opts )
        require('diffview').setup(opts)
      end
  }
}
