return {

  { 'nvim-tree/nvim-web-devicons', opts = { default = true } },
  'NvChad/nvim-colorizer.lua',

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
  {
    'lukas-reineke/indent-blankline.nvim',
    event = 'BufRead',
    config = {
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
  }
}
