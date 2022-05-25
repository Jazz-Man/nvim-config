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

local vim = assert(vim)

local lspconfig = require "lspconfig"

-- local handlers = require "lsp/handlers"
local handlers = vim.lsp.handlers

local on_attach = require 'jz.lsp.on_attach'
local servers = require 'jz.lsp.serverconf'
local capabilities = require 'jz.lsp.capabilities'


-- Enable borders for hover/signature help
handlers["textDocument/hover"] = vim.lsp.with(handlers.hover, { border = 'rounded' })
-- handlers['textDocument/signatureHelp'] = vim.lsp.with(handlers.signature_help, { border = 'rounded' })

handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  underline = true,
  virtual_text = true,
  signs = true,
  update_in_insert = false
})



local function prefer_null_ls_fmt(client)
  client.server_capabilities.documentHighlightProvider = false
  client.server_capabilities.documentFormattingProvider = false
  on_attach(client)
end

for server, config in pairs(servers) do
  if type(config) == 'function' then config = config() end

  if config.prefer_null_ls then
    if config.on_attach then
      local old_on_attach = config.on_attach
      config.on_attach = function(client, bufnr)
        old_on_attach(client, bufnr)
        prefer_null_ls_fmt(client)
      end
    else
      config.on_attach = prefer_null_ls_fmt
    end
  else
    if config.on_attach then
      local old_on_attach = config.on_attach
      config.on_attach = function(client, bufnr)
        old_on_attach(client, bufnr)
        prefer_null_ls_fmt(client)
      end
    else
      config.on_attach = on_attach.on_attach
    end
  end

  config.capabilities = capabilities.setup(config)

  config.on_init = function(client)
    client.config.flags = client.config.flags or {}
    client.config.flags.allow_incremental_sync = true
  end

  config.autostart = true
  config.flags = { debounce_text_changes = 50 }

  lspconfig[server].setup(config)

end
