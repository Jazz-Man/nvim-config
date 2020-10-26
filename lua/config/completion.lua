-- local a = require "utils/general"

vim.g.completion_enable_auto_hover = 1
vim.g.completion_auto_change_source = 1
vim.g.completion_matching_ignore_case = 1
vim.g.completion_enable_auto_paren = 1
-- vim.g.completion_matching_smart_case = 1
-- vim.api.nvim_set_var(
--   "completion_chain_complete_list",
--   {
--     default = {
--       default = {
--         complete_items = {"lsp", "snippet"},
--         mode = "file"
--       },
--       comment = {},
--       string = {}
--     }
--   }
-- )

-- local autocmd = {
--   compilation = {
--     {"BufEnter", [[lua require'completion'.on_attach()]]}
--   }
-- }

-- a.Create_augroup(autocmd)
