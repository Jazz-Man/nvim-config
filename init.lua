return {
  -- Set colorscheme to use
  colorscheme = "onenord",
  -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
  lsp = {
    servers = {
      "awk_ls",
      "bashls",
      "dockerls",
      "html",
      "vimls",
      "dotls",
      "yamlls",
      "jsonls",
      "lua_ls",
      "lemminx",
      "cssls",
      "cssmodules_ls",
    },
  },
}
