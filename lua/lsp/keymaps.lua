local utils = require "utils"

local M = {}


function M.setup(client, bufnr)

    local opts = {noremap = true, silent = true}
    -- vim.api.nvim_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    -- vim.api.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    vim.api.nvim_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    -- vim.api.nvim_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    vim.api.nvim_set_keymap("n", "<C-k>","<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)

end

return M
