return {
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },

    opts = {
      signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`,
      numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
      linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
      word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
      current_line_blame = false -- Toggle with `:Gitsigns toggle_current_line_blame`
    }
  }
}
