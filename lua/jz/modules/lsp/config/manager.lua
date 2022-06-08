local M = {}

local lsp_utils = require 'jz.modules.lsp.config.utils'
local lsp_keymap = require 'jz.modules.lsp.config.keymap'
local utils = require('jz.utils')
local extend = vim.tbl_deep_extend

function M.common_on_exit(_, _)

  utils.clear_augroup('lsp_document_highlight')
  utils.clear_augroup('lsp_code_lens_refresh')

end

local function lsp_highlight_document(client)
  -- Set autocommands conditional on server_capabilities
  local status_ok, illuminate = pcall(require, 'illuminate')
  if not status_ok then return end
  illuminate.on_attach(client)
end

function M.common_on_attach(client, bufnr)

  client.server_capabilities.documentHighlightProvider = true
  client.server_capabilities.documentFormattingProvider = true

  require 'lsp-format'.on_attach(client)

  lsp_keymap.setup(client, bufnr)
  lsp_highlight_document(client)
  lsp_utils.setup_codelens_refresh(client, bufnr)

  vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

  -- Per buffer LSP indicators control
  if vim.b.lsp_virtual_text_enabled == nil then
    vim.b.lsp_virtual_text_enabled = true
  end

  if vim.b.lsp_virtual_text_mode == nil then
    vim.b.lsp_virtual_text_mode = 'SignsVirtualText'
  end

end

function M.common_on_init(client, _)

  client.config.flags = client.config.flags or {}
  client.config.flags.allow_incremental_sync = true
end

local function common_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { 'documentation', 'detail', 'additionalTextEdits' }
  }

  local status_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
  if status_ok then
    capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
  end

  return capabilities
end

---@param server_config table
---@return table
local function resolve_config(server_config)

  local defaults = {
    on_attach = M.common_on_attach,
    on_init = M.common_on_init,
    on_exit = M.common_on_exit,
    capabilities = common_capabilities(),
    autostart = true,
    flags = { debounce_text_changes = 50, allow_incremental_sync = true }
  }

  if server_config.on_attach then

    local old_on_attach = server_config.on_attach

    defaults.on_attach = function(client, bufnr)

      old_on_attach(client, bufnr)
      M.common_on_attach(client, bufnr)
    end
  end

  if server_config.on_init then
    local old_on_init = server_config.on_init

    defaults.on_init = function(client, bufnr)
      old_on_init(client, bufnr)
      M.common_on_init(client, bufnr)
    end
  end

  if server_config.on_exit then

    local old_on_exit = server_config.on_exit

    defaults.on_exit = function(client, bufnr)
      old_on_exit(client, bufnr)
      M.common_on_exit(client, bufnr)
    end
  end

  if server_config.flags then

    defaults.flags = extend('force', defaults.flags, server_config.flags or {})

  end

  if server_config.capabilities then

    defaults.capabilities = extend(
      'force', defaults.capabilities,
      server_config.capabilities or {}
    )
  end

  return defaults

end

---comment
---@param server_name string
---@param server_config table|nil
function M.setup(server_name, server_config)

  local lspconfig = require 'lspconfig'
  -- local null_ls_ok, null_ls = pcall(require, 'null-ls')

  vim.validate { name = { server_name, 'string' } }

  server_config = server_config or {}

  server_config = resolve_config(server_config)

  lspconfig[server_name].setup(server_config)

end

return M
