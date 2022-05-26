local navigator = require('navigator')


navigator.setup({

  lsp_signature_help = true,
  signature_help_cfg = {

    bind = true,
    doc_lines = 0,
    floating_window = true,
    fix_pos = true,
    hint_enable = true,
    hint_prefix = " ",
    hint_scheme = "String",
    hi_parameter = "Search",
    max_height = 22,
    max_width = 120, -- max_width of signature floating_window, line will be wrapped if exceed max_width
    handler_opts = {
      border = "single", -- double, single, shadow, none
    },
    zindex = 200, -- by default it will be on top of all floating windows, set to 50 send it to bottom
    padding = "", -- character to pad on left and right of signature can be ' ', or '|'  etc
  },
  lsp_installer = true,

  treesitter_analysis = true,
  default_mapping = true,
  icons = {
    icons = false
  },


  lsp = {
    diagnostic_load_files = true,
    diagnostic_update_in_insert = true,
    disable_lsp = {
      'ccls',
      'rust_analyzer',
      'clangd',
      'clojure_lsp',
      'sourcekit',
      'terraformls',
      'omnisharp'
    }
  }
})
