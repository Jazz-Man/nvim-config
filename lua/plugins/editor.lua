local utils = require 'jz.utils'
local icons = require 'jz.config.icons'

return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    cmd = 'Neotree',
    deactivate = function() vim.cmd([[Neotree close]]) end,
    init = function()
      vim.g.neo_tree_remove_legacy_commands = 1;

      if vim.fn.argc() == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == 'directory' then require('neo-tree') end
      end
    end,
    opts = {
      sources = { 'filesystem', 'buffers', 'git_status', 'document_symbols' },
      filesystem = { follow_current_file = true, use_libuv_file_watcher = true },
      window = { mappings = { ['<space>'] = 'none' } },
      default_component_configs = {
        indent = {
          with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = '',
          expander_expanded = '',
          expander_highlight = 'NeoTreeExpander'
        }
      }
    },
    config = function( _, opts )

      require('neo-tree').setup(opts)
      vim.api.nvim_create_autocmd(
        'TermClose', {
          pattern = '*lazygit',
          callback = function()
            if package.loaded['neo-tree.sources.git_status'] then
              require('neo-tree.sources.git_status').refresh()
            end
          end
        }
      )
    end
  },

  -- search/replace in multiple files
  {
    'nvim-pack/nvim-spectre',
    keys = {

      {
        '<leader>sr',
        function() require('spectre').open() end,
        desc = 'Replace in files (Spectre)'
      }

    }
  }
}
