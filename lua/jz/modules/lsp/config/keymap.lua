local M = {}

local utils = require 'jz.utils'

function M.setup(client, bufnr)

  local bufopts = { buffer = bufnr }

  utils.nmap('gD', vim.lsp.buf.declaration, bufopts)
  utils.nmap('gd', vim.lsp.buf.definition, bufopts)
  utils.nmap('K', vim.lsp.buf.hover, bufopts)
  utils.nmap('gi', vim.lsp.buf.implementation, bufopts)

  utils.nmap('gs', vim.lsp.buf.signature_help, bufopts)

  utils.nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  utils.nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)

  utils.nmap('<leader>ci', vim.lsp.buf.incoming_calls, bufopts)
  utils.nmap('<leader>co', vim.lsp.buf.outgoing_calls, bufopts)

  utils.nmap('<leader>ca', vim.lsp.buf.code_action, bufopts)
  utils.vmap('<leader>ca', vim.lsp.buf.range_code_action, bufopts)

  if client.server_capabilities.documentFormattingProvider then
    utils.nmap('<leader>f', vim.lsp.buf.format)
  end

end

return M
