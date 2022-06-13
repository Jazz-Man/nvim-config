local M = {}

local lsp_utils = require('jz.lsp.utils')
local lsp_keymap = require('jz.lsp.keymap')
local utils = require('jz.utils')

local lspconfig = require 'lspconfig'

local function common_on_exit( _, _ )

    utils.clear_augroup('lsp_document_highlight')
    utils.clear_augroup('lsp_code_lens_refresh')

end

local function common_on_attach( client, bufnr )

    lsp_keymap.setup(client, bufnr)
    lsp_utils.setup_document_highlight(client, bufnr)
    lsp_utils.setup_codelens_refresh(client, bufnr)
    lsp_utils.lsp_signature(client, bufnr)

    vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Per buffer LSP indicators control
    if vim.b.lsp_virtual_text_enabled == nil then
        vim.b.lsp_virtual_text_enabled = true
    end

    if vim.b.lsp_virtual_text_mode == nil then
        vim.b.lsp_virtual_text_mode = 'SignsVirtualText'
    end

end

local function common_on_init( client, _ )

    client.config.flags = client.config.flags or {}
    client.config.flags.allow_incremental_sync = true
end

local function common_capabilities()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = {'documentation', 'detail', 'additionalTextEdits'}
    }

    local status_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
    if status_ok then
        capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
    end

    return capabilities
end

local function resolve_config( server_config )

    local defaults = {
        on_attach = common_on_attach,
        on_init = common_on_init,
        on_exit = common_on_exit,
        capabilities = common_capabilities(),
        autostart = true,
        flags = {debounce_text_changes = 50}
    }

    if server_config.on_attach then

        local old_on_attach = server_config.on_attach

        defaults.on_attach = function( client, bufnr )

            old_on_attach(client, bufnr)
            common_on_attach(client, bufnr)
        end
    end

    if server_config.on_init then
        local old_on_init = server_config.on_init

        defaults.on_init = function( client, bufnr )
            old_on_init(client, bufnr)
            common_on_init(client, bufnr)
        end
    end

    if server_config.on_exit then

        local old_on_exit = server_config.on_exit

        defaults.on_exit = function( client, bufnr )
            old_on_exit(client, bufnr)
            common_on_exit(client, bufnr)
        end
    end

    if server_config.flags then

        defaults.flags = vim.tbl_deep_extend(
                           'force', defaults.flags, server_config.flags or {}
                         )

    end

    if server_config.capabilities then

        defaults.capabilities = vim.tbl_deep_extend(
                                  'force', defaults.capabilities,
                                  server_config.capabilities or {}
                                )
    end

    return defaults

end

function M.setup( server_name, server_config )

    vim.validate {name = {server_name, 'string'}}

    server_config = server_config or {}

    server_config = resolve_config(server_config)

    lspconfig[server_name].setup(server_config)

end

return M
