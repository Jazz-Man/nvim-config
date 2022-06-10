local M = {}

local utils = require 'jz.utils'
local handlers = vim.lsp.handlers

function M.setup_handlers()

  local icons = require('jz.config.icons')

  local lsp_float = { focusable = true, style = 'minimal', border = 'rounded' }

  local config = {

    virtual_text = { prefix = icons.icons.warningCircle },
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    signs = {
      active = true,
      values = {
        { name = 'DiagnosticSignError', text = icons.lsp.error },
        { name = 'DiagnosticSignWarn', text = icons.lsp.warn },
        { name = 'DiagnosticSignHint', text = icons.lsp.hint },
        { name = 'DiagnosticSignInfo', text = icons.lsp.info }
      }
    },
    float = {
      focusable = false,
      style = 'minimal',
      border = 'rounded',
      source = 'always',
      header = '',
      prefix = '',
      format = function(d)
        local t = vim.deepcopy(d)
        local code = d.code or (d.user_data and d.user_data.lsp.code)
        if code then
          t.message = string.format('%s [%s]', t.message, code):gsub('1. ', '')
        end
        return t.message
      end
    }
  }

  vim.diagnostic.config(config)
  handlers['textDocument/hover'] = vim.lsp.with(handlers.hover, lsp_float)
  handlers['textDocument/signatureHelp'] = vim.lsp.with(
    handlers.signature_help, lsp_float
  )
end

function M.setup_codelens_refresh(client, bufnr)
  local status_ok, codelens_supported = pcall(
    function()
      return client.supports_method 'textDocument/codeLens'
    end
  )
  if not status_ok or not codelens_supported then return end

  utils.autocommand(
    {
      lsp_code_lens_refresh = {
        {
          event = { 'BufEnter', 'InsertLeave' },
          options = {
            group = 'lsp_code_lens_refresh',
            buffer = bufnr,
            callback = vim.lsp.codelens.refresh

          }
        }
      }
    }
  )

end

return M
