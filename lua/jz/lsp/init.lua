-- prevents luacheck from making lints for setting things on vim
pcall(function()
  require("nvim-lsp-installer").setup({
    ensure_installed = { "sumneko_lua" },
    ui = {
      icons = {
        server_installed = "✓",
        server_pending = "➜",
        server_uninstalled = "✗"
      }
    }
  })
end)



local servers = require 'jz.lsp.serverconf'
local lsp_manager = require 'jz.lsp.manager'

local lsp_utils = require('jz.lsp.utils')

lsp_utils.setup_handlers()

for server, config in pairs(servers) do

  lsp_manager.setup(server, config)
end

lsp_manager.setup("awk_ls")
lsp_manager.setup("bashls")
lsp_manager.setup("dockerls")
lsp_manager.setup("html")
lsp_manager.setup("vimls")
lsp_manager.setup("tsserver")
