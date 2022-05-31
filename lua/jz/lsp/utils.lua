local M = {}

local utils = require 'jz.utils'

function M.setup_document_highlight(client, bufnr)
  if client.server_capabilities.documenthighlightprovider then

    utils.autocommand({
      lsp_document_highlight = {
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

end

function M.setup_handlers()

  local icons = require('jz.config.icons')

  local lsp_float = {
    focusable = true,
    style = "minimal",
    border = "rounded",
  }


  local config = {

    virtual_text = true,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    signs = {
      active = true,
      values = {
        { name = "DiagnosticSignError", text = icons.lsp.error },
        { name = "DiagnosticSignWarn", text = icons.lsp.warn },
        { name = "DiagnosticSignHint", text = icons.lsp.hint },
        { name = "DiagnosticSignInfo", text = icons.lsp.info },
      },
    },
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
      format = function(d)
        local t = vim.deepcopy(d)
        local code = d.code or (d.user_data and d.user_data.lsp.code)
        if code then
          t.message = string.format("%s [%s]", t.message, code):gsub("1. ", "")
        end
        return t.message
      end,
    },
  }

  vim.diagnostic.config(config)
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, lsp_float)
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, lsp_float)
end

function M.setup_codelens_refresh(client, bufnr)
  local status_ok, codelens_supported = pcall(function()
    return client.supports_method "textDocument/codeLens"
  end)
  if not status_ok or not codelens_supported then
    return
  end

  utils.autocommand({
    lsp_code_lens_refresh = {
      {
        event = { "BufEnter", "InsertLeave" },
        options = {
          group = "lsp_code_lens_refresh",
          buffer = bufnr,
          callback = vim.lsp.codelens.refresh,

        }
      }
    }
  })

end

function M.lsp_signature(_, bufnr)

  local status_ok, lsp_signature = pcall(require, "lsp_signature")

  if not status_ok then
    return
  end


  lsp_signature.on_attach({
    bind = true,
    doc_lines = 0,
    floating_window = true,
    fix_pos = true,
    hint_enable = true,
    hint_prefix = " ",
    hint_scheme = "String",
    hi_parameter = "Search",
    max_height = 22,
    max_width = 120, -- max_width of signature floating_window, line will be wrapped if exceed max_width
    handler_opts = {
      border = "single", -- double, single, shadow, none
    },
    zindex = 200, -- by default it will be on top of all floating windows, set to 50 send it to bottom
    padding = "", -- character to pad on left and right of signature can be ' ', or '|'  etc
  }, bufnr)
end

---filter passed to vim.lsp.buf.format
---gives higher priority to null-ls
---@param clients table clients attached to a buffer
---@return table chosen clients
function M.format_filter(clients)
  return vim.tbl_filter(function(client)
    local status_ok, formatting_supported = pcall(function()
      return client.supports_method "textDocument/formatting"
    end)
    -- give higher prio to null-ls
    if status_ok and formatting_supported and client.name == "null-ls" then
      return "null-ls"
    else
      return status_ok and formatting_supported and client.name
    end
  end, clients)
end

---Provide vim.lsp.buf.format for nvim <0.8
---@param opts table
function M.format(opts)
  opts = opts or { filter = M.format_filter }

  if vim.lsp.buf.format then
    return vim.lsp.buf.format(opts)
  end

  local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()
  local clients = vim.lsp.buf_get_clients(bufnr)

  if opts.filter then
    clients = opts.filter(clients)
  elseif opts.id then
    clients = vim.tbl_filter(function(client)
      return client.id == opts.id
    end, clients)
  elseif opts.name then
    clients = vim.tbl_filter(function(client)
      return client.name == opts.name
    end, clients)
  end

  clients = vim.tbl_filter(function(client)
    return client.supports_method "textDocument/formatting"
  end, clients)

  if #clients == 0 then
    vim.notify "[LSP] Format request failed, no matching language servers."
  end

  local timeout_ms = opts.timeout_ms or 1000
  for _, client in pairs(clients) do
    local params = vim.lsp.util.make_formatting_params(opts.formatting_options)
    local result, err = client.request_sync("textDocument/formatting", params, timeout_ms, bufnr)
    if result and result.result then
      vim.lsp.util.apply_text_edits(result.result, bufnr, client.offset_encoding)
    elseif err then
      vim.notify(string.format("[LSP][%s] %s", client.name, err), vim.log.levels.WARN)
    end
  end
end

return M
