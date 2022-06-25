local M = {}

local handlers = vim.lsp.handlers

function M.setup_handlers()

  local icons = require('jz.config.icons')

  local lsp_float = { focusable = true, style = 'minimal', border = 'rounded' }

  local config = {

    virtual_text = { prefix = icons.icons.warningCircle, source = true },
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



return M
