local handlers = require "lsp/handlers"
local lsp_keymaps = require "lsp/keymaps"

local cmp = prequire('cmp_nvim_lsp')

local servers = prequire("lsp/serverconf")

local function lsp_highlight_document(client)
  -- Set autocommands conditional on server_capabilities
  -- dump(client)
  -- if client.resolved_capabilities.document_highlight then
  vim.api.nvim_exec([[
        augroup lsp_document_highlight
          autocmd! * <buffer>
          autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
          autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        augroup END
      ]], false)
  -- end
end

local function on_attach(client, bufnr)

  lsp_highlight_document(client)

  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  handlers.setup(bufnr)
  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  lsp_keymaps.setup(client, bufnr)

  -- See `:help vim.lsp.*` for documentation on any of the below functions

  -- K.Key_mapper("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", true)
  -- K.Key_mapper("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", true)
  -- K.Key_mapper("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", true)
  -- K.Key_mapper("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>",true)
  -- K.Key_mapper("n", "g0", "<cmd>lua vim.lsp.buf.document_symbol()<CR>",true)
  -- K.Key_mapper("n", "gW", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>",true)
  -- K.Key_mapper("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", true)

  -- K.Key_mapper("n", "<Leader>de", "<cmd>lua vim.lsp.buf.declaration()<CR>", true)
  -- K.Key_mapper("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>",true)
  -- K.Key_mapper("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", true)
  -- K.Key_mapper("n", "ga", "<cmd>lua vim.lsp.buf.code_action()<CR>", true)
  -- K.Key_mapper("n", "gD", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>",true)

  -- -- DiagnosticCycle
  -- K.Key_mapper("n", "]d","<cmd>lua vim.lsp.diagnostic.goto_prev { wrap = false }<CR>",true)
  -- K.Key_mapper("n", "[d",                     "<cmd>lua vim.lsp.diagnostic.goto_next { wrap = false }<CR>",true)
  -- -- Diagnostic
  -- K.Key_mapper("n", "[D", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>",true)
  -- K.Key_mapper("n", "]D", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>",true)

  -- -- OpenDiagnostic
  -- K.Key_mapper("n", "pd", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>",true)

  -- if client.resolved_capabilities.document_formatting then
  --     K.Key_mapper("n", "<leader>lf",
  --                  "<cmd>lua vim.lsp.buf.formatting()<cr>", true)
  -- else
  --     -- K.Key_mapper("n", "<Leader>lf", "<cmd>Format<CR>", true)
  -- end

  -- local lsp_event = {}

  -- if client.resolved_capabilities.document_highlight then
  --     lsp_event.highlights = {
  --         {
  --             "CursorHold,CursorHoldI", "<buffer>",
  --             "lua vim.lsp.buf.document_highlight()"
  --         },
  --         {
  --             "CursorMoved", "<buffer>",
  --             "lua vim.lsp.buf.clear_references()"
  --         }
  --     }
  -- end

  -- K.Create_augroup(lsp_event)
  -- if config.after then config.after(client) end
  -- end
end

local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp
.protocol
.make_client_capabilities())

local options = {
  on_attach = on_attach,
  capabilities = capabilities,
  autostart = true,
  flags = { debounce_text_changes = 150 }
}


if servers then

  require("lsp/install").setup(servers, options)
end
