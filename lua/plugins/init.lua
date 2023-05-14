return {
  'lewis6991/impatient.nvim',
  { 'ojroques/nvim-bufdel', cmd = 'BufDel' },
  'norcalli/nvim_utils',
  -- library used by other plugins
  { 'nvim-lua/plenary.nvim', lazy = true },
  {
    'dstein64/vim-startuptime',
    cmd = 'StartupTime',
    config = function() vim.g.startuptime_tries = 10 end
  },
  {
    'folke/persistence.nvim',
    event = 'BufReadPre',
    opts = {
      options = { 'buffers', 'curdir', 'tabpages', 'winsize', 'help', 'globals' }
    },
    keys = {
      {
        '<leader>qs',
        function() require('persistence').load() end,
        desc = 'Restore Session'
      },
      {
        '<leader>ql',
        function() require('persistence').load({ last = true }) end,
        desc = 'Restore Last Session'
      },
      {
        '<leader>qd',
        function() require('persistence').stop() end,
        desc = 'Don\'t Save Current Session'
      }
    }
  }
}