local lspactions = prequire("lspactions")
local utils = require('utils')

local M = {}

local handlers = vim.lsp.handlers;


local function lsp_locations_config(bufnr)

  local status_ok, locations = pcall(require, 'lsputil.locations')
  if not status_ok then return end


  handlers['textDocument/typeDefinition'] = function(_, method, result)
    locations.typeDefinition_handler(nil, result,
      { bufnr = bufnr, method = method },
      nil)
  end


end

local function lsp_symbols_config(bufnr)

  local symbols = prequire('lsputil.symbols')

  if symbols then

    handlers['textDocument/documentSymbol'] = symbols.document_handler
    handlers['textDocument/symbol'] = symbols.workspace_handler
  end

end

local function lsp_diagnostic_config()
  local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  local config = {
    -- disable virtual text
    virtual_text = false,
    -- show signs
    signs = {
      active = signs,
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  }

  vim.diagnostic.config(config)

end

function M.setup(bufnr)

  if lspactions then
    vim.lsp.handlers["textDocument/codeAction"] = lspactions.codeaction
    utils.nmap('<leader>af', lspactions.code_action)
    utils.nmap('<leader>af', lspactions.range_code_action)


    vim.lsp.handlers["textDocument/references"] = lspactions.references
    utils.nmap('<leader>af', vim.lsp.buf.references)

    vim.lsp.handlers["textDocument/definition"] = lspactions.definition
    utils.nmap('<leader>af', vim.lsp.buf.definition)

    vim.lsp.handlers["textDocument/declaration"] = lspactions.declaration
    utils.nmap('<leader>af', vim.lsp.buf.declaration)

    vim.lsp.handlers["textDocument/implementation"] = lspactions.implementation
    utils.nmap('<leader>af', vim.lsp.buf.implementation)

  end


  lsp_locations_config(bufnr)
  lsp_symbols_config(bufnr)
  lsp_diagnostic_config()

  handlers["textDocument/hover"] = vim.lsp.with(handlers.hover, {
    border = "rounded",
  })


  handlers["textDocument/signatureHelp"] = vim.lsp.with(handlers.signature_help, {
    border = "rounded",
  })

end

return M
