local M = {}

local extend = vim.tbl_deep_extend
local au = require 'jz.utils.autocmd'

---@param client any
---@param method string
---@return boolean
local function check_support( client, method )

  local ok, supported = pcall(
                          function() return client.supports_method(method) end
                        )

  return ok and supported
end

function M.common_on_exit( _, _ )

  au:clean('lsp_document_highlight')

  au:clean('lsp_code_lens_refresh')

end

function M.common_on_attach( client, bufnr )

  -- client.server_capabilities.documentHighlightProvider = true
  -- client.server_capabilities.documentFormattingProvider = true

  -- vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

  if check_support(client, 'textDocument/documentHighlight') then

    au:au_group(
      { buffer = bufnr, group = 'lsp_document_highlight' }, function()

        au:au():event({ 'CursorHold', 'CursorHoldI' }):callback(
          vim.lsp.buf.document_highlight
        )
        au:au():event({ 'CursorMoved', 'CursorMovedI' }):callback(
          vim.lsp.buf.clear_references
        )

      end
    )
  end

  if check_support(client, 'textDocument/codeLens') then

    au:au():group('lsp_code_lens_refresh'):event({ 'BufEnter', 'InsertLeave' })
      :callback(
        vim.lsp.codelens.refresh
      )

  end
  au:au_group(
    { buffer = bufnr, group = 'lsp_config', desc = 'LSP' }, function()

      au:au():desc('Show diagnostic'):event({ 'CursorHold', 'CursorHoldI' })
        :callback(
          function()

            local opts = {
              focusable = false,
              close_events = {
                'BufLeave',
                'CursorMoved',
                'InsertEnter',
                'FocusLost'
              }
            }
            vim.diagnostic.open_float(nil, opts)
          end
        )

    end
  )

end

function M.common_on_init( client, _ )

  client.config.flags = client.config.flags or {}
  client.config.flags.allow_incremental_sync = true
end

---@param server_config table
---@return table
function M.resolve_config( server_config )

  local defaults = {
    on_attach = M.common_on_attach,
    on_init = M.common_on_init,
    on_exit = M.common_on_exit,
    autostart = true,
    flags = { debounce_text_changes = 50, allow_incremental_sync = true }
  }

  if server_config.on_attach then

    local old_on_attach = server_config.on_attach

    defaults.on_attach = function( client, bufnr )

      old_on_attach(client, bufnr)
      M.common_on_attach(client, bufnr)
    end
  end

  if server_config.on_init then
    local old_on_init = server_config.on_init

    defaults.on_init = function( client, bufnr )
      old_on_init(client, bufnr)
      M.common_on_init(client, bufnr)
    end
  end

  if server_config.on_exit then

    local old_on_exit = server_config.on_exit

    defaults.on_exit = function( client, bufnr )
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
function M.setup( server_name, server_config )

  local lspconfig = require 'lspconfig'

  vim.validate { name = { server_name, 'string' } }

  server_config = server_config or {}

  server_config = M.resolve_config(server_config)

  lspconfig[server_name].setup(server_config)

end

return M
