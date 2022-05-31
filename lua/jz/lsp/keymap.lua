local M = {}

local utils = require 'jz.utils'

function M.setup(client, bufnr)

  local k_options = { buffer = bufnr }


  utils.nmap("K", vim.lsp.buf.hover, k_options)
  utils.nmap("gs", vim.lsp.buf.signature_help, k_options)

  utils.map_tele('n', 'gr', 'lsp_references', nil, bufnr)
  utils.map_tele('n', 'gd', 'lsp_definitions', nil, bufnr)
  utils.map_tele('n', 'gt', 'lsp_type_definition', nil, bufnr)

  utils.map_tele('n', 'gi', 'lsp_implementations', nil, bufnr)
  utils.map_tele('n', 'g0', 'lsp_document_symbols', nil, bufnr)
  utils.map_tele('n', 'gW', 'lsp_workspace_symbols', nil, bufnr)

  utils.map_tele('n', 'gD', 'diagnostics', { bufnr = bufnr })

  utils.nmap('<leader>af', vim.lsp.buf.code_action, k_options)
  utils.vmap('<leader>af', vim.lsp.buf.range_code_action, k_options)
  utils.nmap("<Leader>de", vim.lsp.buf.declaration, k_options)
  utils.nmap("<leader>rn", vim.lsp.buf.rename, k_options)

  if client.server_capabilities.documentFormattingProvider then
    utils.nmap('<leader>f', vim.lsp.buf.format)
  end


end

return M
