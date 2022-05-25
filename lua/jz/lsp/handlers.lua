local lspactions = prequire("lspactions")
local utils = require('utils')

local M = {}

local handlers = vim.lsp.handlers;

function M.setup(bufnr)

    if lspactions then
        utils.nmap('<leader>af', lspactions.code_action)
        utils.nmap('<leader>af', lspactions.range_code_action)

        utils.nmap('<leader>af', vim.lsp.buf.references)

        utils.nmap('<leader>af', vim.lsp.buf.definition)

        utils.nmap('<leader>af', vim.lsp.buf.declaration)
        utils.nmap('<leader>af', vim.lsp.buf.implementation)

    end

    handlers["textDocument/signatureHelp"] = vim.lsp.with(
                                                 handlers.signature_help,
                                                 {border = "rounded"})

end

return M
