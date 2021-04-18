local K = require "utils/general"

local servers = require "lsp/serverconf"
local util = require "lspconfig/util"
local nvim_lsp = require "lspconfig"
local lsp_status = require "lsp-status"
local completion = require "completion"

lsp_status.config {
  kind_labels = vim.g.completion_customize_lsp_label,
  select_symbol = function(cursor_pos, symbol)
    if symbol.valueRange then
      local value_range = {
        ["start"] = {
          character = 0,
          line = vim.fn.byte2line(symbol.valueRange[1])
        },
        ["end"] = {
          character = 0,
          line = vim.fn.byte2line(symbol.valueRange[2])
        }
      }

      return require("lsp-status/util").in_range(cursor_pos, value_range)
    end
  end
}

lsp_status.register_progress()

vim.lsp.handlers["textDocument/codeAction"] = require "lsputil.codeAction".code_action_handler
vim.lsp.handlers["textDocument/references"] = require "lsputil.locations".references_handler
vim.lsp.handlers["textDocument/definition"] = require "lsputil.locations".definition_handler
vim.lsp.handlers["textDocument/declaration"] = require "lsputil.locations".declaration_handler
vim.lsp.handlers["textDocument/typeDefinition"] = require "lsputil.locations".typeDefinition_handler
vim.lsp.handlers["textDocument/implementation"] = require "lsputil.locations".implementation_handler
vim.lsp.handlers["textDocument/documentSymbol"] = require "lsputil.symbols".document_handler
vim.lsp.handlers["workspace/symbol"] = require "lsputil.symbols".workspace_handler

local function make_on_attach(config, bufnr)
  return function(client)
    if config.before then
      config.before(client)
    end

    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
    lsp_status.on_attach(client, bufnr)
    completion.on_attach(client, bufnr)

    K.Key_mapper("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", true)
    K.Key_mapper("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", true)
    K.Key_mapper("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", true)
    K.Key_mapper("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>", true)
    K.Key_mapper("n", "g0", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", true)
    K.Key_mapper("n", "gW", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>", true)
    K.Key_mapper("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", true)

    K.Key_mapper("n", "<Leader>de", "<cmd>lua vim.lsp.buf.declaration()<CR>", true)
    K.Key_mapper("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", true)
    K.Key_mapper("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", true)
    K.Key_mapper("n", "ga", "<cmd>lua vim.lsp.buf.code_action()<CR>", true)
    K.Key_mapper("n", "gD", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", true)

    -- DiagnosticCycle
    K.Key_mapper("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_prev { wrap = false }<CR>", true)
    K.Key_mapper("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_next { wrap = false }<CR>", true)
    -- Diagnostic
    K.Key_mapper("n", "[D", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", true)
    K.Key_mapper("n", "]D", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", true)

    -- OpenDiagnostic
    K.Key_mapper("n", "pd", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", true)

    if client.resolved_capabilities.document_formatting then
      K.Key_mapper("n", "<leader>lf", "<cmd>lua vim.lsp.buf.formatting()<cr>", true)
    else
      K.Key_mapper("n", "<Leader>lf", "<cmd>Format<CR>", true)
    end

    local lsp_event = {}

    if client.resolved_capabilities.document_highlight then
      lsp_event.highlights = {
        {"CursorHold,CursorHoldI", "<buffer>", "lua vim.lsp.buf.document_highlight()"},
        {"CursorMoved", "<buffer>", "lua vim.lsp.buf.clear_references()"}
      }
    end

    K.Create_augroup(lsp_event)
    if config.after then
      config.after(client)
    end
  end
end

local snippet_capabilities = {
  textDocument = {
    completion = {
      completionItem = {
        snippetSupport = true
      }
    }
  }
}

for server, config in pairs(servers) do
  config.on_attach = make_on_attach(config)
  config.capabilities =
    util.tbl_deep_extend("keep", config.capabilities or {}, lsp_status.capabilities, snippet_capabilities)

  nvim_lsp[server].setup(config)
end
