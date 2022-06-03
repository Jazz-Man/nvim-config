local M = {}

local lsp_utils = require 'jz.modules.lsp.config.utils'
local lsp_keymap = require 'jz.modules.lsp.config.keymap'
local utils = require('jz.utils')
local extend = vim.tbl_deep_extend

local function common_on_exit( _, _ )

    utils.clear_augroup('lsp_document_highlight')
    utils.clear_augroup('lsp_code_lens_refresh')

end

local function common_on_attach( client, bufnr )

    client.server_capabilities.documentHighlightProvider = true
    client.server_capabilities.documentFormattingProvider = true

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

---@param server_name string
---@return table|nil
local function resolve_null_ls_config( server_name )

    local res, null_ls = pcall(require, 'null-ls')
    if not res then return nil end

    local formatting = null_ls.builtins.formatting
    local diagnostics = null_ls.builtins.diagnostics
    local code_actions = null_ls.builtins.code_actions
    local completion = null_ls.builtins.completion

    local sources = {
        -- completion.luasnip,
        completion.spell,
        completion.tags,
        diagnostics.trail_space
    }

    if server_name == 'sumneko_lua' then

        table.insert(
          sources, {
              diagnostics.luacheck,
              formatting.lua_format.with(
                {extra_args = {'-c', '~/.config/luaformatter/config.yaml'}}
              )
          }
        )
    end

    if server_name == 'bashls' then
        table.insert(sources, {diagnostics.shellcheck, code_actions.shellcheck})
    end

    if server_name == 'sqls' then

        table.insert(sources, {diagnostics.sqlfluff, formatting.sqlfluff})

    end

    if server_name == 'intelephense' then

        table.insert(
          sources, {
              diagnostics.php,
              diagnostics.psalm,
              diagnostics.phpstan,
              diagnostics.phpmd,
              formatting.phpcsfixer
          }
        )

    end

    if server_name == 'jsonls' then table.insert(sources, {formatting.jq}) end

    return sources

end

---@param server_config table
---@return table
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

        defaults.flags = extend(
                           'force', defaults.flags, server_config.flags or {}
                         )

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
    -- local null_ls_ok, null_ls = pcall(require, 'null-ls')

    vim.validate {name = {server_name, 'string'}}

    server_config = server_config or {}

    server_config = resolve_config(server_config)

    lspconfig[server_name].setup(server_config)

    -- local null_ls_sources = resolve_null_ls_config(server_name)

    -- if null_ls_ok and null_ls_sources then

    --     null_ls.setup(
    --       {
    --           debug = true,
    --           log = {enable = true, level = 'warn', use_console = 'async'},
    --           on_attach = server_config.on_attach,
    --           on_init = server_config.on_init,
    --           on_exit = server_config.on_exit,
    --           update_in_insert = false,
    --           sources = null_ls_sources
    --       }
    --     )

    -- end

end

function M.setup_null_ls()
    local null_ls_ok, null_ls = pcall(require, 'null-ls')

    if not null_ls_ok then return end

    local formatting = null_ls.builtins.formatting
    local diagnostics = null_ls.builtins.diagnostics
    local code_actions = null_ls.builtins.code_actions
    local completion = null_ls.builtins.completion

    local sources = {
        -- completion.luasnip,
        code_actions.refactoring,
        completion.spell,
        completion.tags,
        diagnostics.trail_space,
        diagnostics.luacheck
    }

    null_ls.setup(
      {
          debug = true,
          log = {enable = true, level = 'warn', use_console = 'async'},
          on_attach = common_on_attach,
          on_init = common_on_init,
          on_exit = common_on_exit,
          sources = sources
      }
    )

end

return M
