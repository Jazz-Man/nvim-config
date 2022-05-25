local M = {}



---@param config table
function M.setup(config)


  local capabilities = vim.lsp.protocol.make_client_capabilities()
  --[[ capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      "documentation",
      'detail',
      'additionalTextEdits'
    }
  }
]]

  --[[ capabilities.textDocument.completion.completionItem = {
    documentationFormat = { "markdown", "plaintext" },
    snippetSupport = true,
    preselectSupport = true,
    insertReplaceSupport = true,
    labelDetailsSupport = true,
    deprecatedSupport = true,
    commitCharactersSupport = true,
    tagSupport = { valueSet = { 1 } },
    resolveSupport = {
      properties = {
        "documentation",
        "detail",
        "additionalTextEdits",
      },
    },
  } ]]


  local cmp_ok, cmp = pcall(require, "cmp_nvim_lsp")

  if cmp_ok then

    capabilities = cmp.update_capabilities(capabilities)


  end

  capabilities.offsetEncoding = { 'utf-16' }


  return vim.tbl_deep_extend("keep", config.capabilities or {}, capabilities)

end

return M
