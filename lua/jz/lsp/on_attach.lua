local vim = assert(vim)

local utils = require 'jz.utils'


local M = {}

function M.on_attach(client, bufnr)

  if client.server_capabilities.documenthighlightprovider then

    utils.autocommand({
      lsp_aucmds = {
        {
          event = { 'CursorHold', 'CursorHoldI' },
          options = {
            buffer = bufnr,
            callback = vim.lsp.buf.document_highlight
          }
        },
        {
          event = { 'CursorMoved', 'CursorMovedI' },
          options = {
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references
          }
        }
      }
    })
  end

  vim.api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    callback = function()
      local opts = {
        focusable = false,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        border = 'rounded',
        source = 'always',
        prefix = ' ',
        scope = 'cursor'
      }
      vim.diagnostic.open_float(nil, opts)
    end
  })

  require 'lsp_signature'.on_attach({
    bind = true,
    handler_opts = {
      border = "single"
    }
  }, bufnr)

  vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"

  -- See `:help vim.lsp.*` for documentation on any of the below function

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

  -- Per buffer LSP indicators control
  if vim.b.lsp_virtual_text_enabled == nil then
    vim.b.lsp_virtual_text_enabled = true
  end

  if vim.b.lsp_virtual_text_mode == nil then
    vim.b.lsp_virtual_text_mode = 'SignsVirtualText'
  end

end

return M
