local a = require "utils/general"
local global = require "utils/global"

vim.g.completion_enable_auto_hover = 0
vim.g.completion_auto_change_source = 1
vim.g.completion_matching_ignore_case = 1
vim.g.completion_enable_auto_paren = 1
vim.g.completion_enable_snippet = "vim-vsnip"
vim.g.completion_matching_smart_case = 1


vim.g.vsnip_snippet_dir = global.snippet_dir

vim.g.sonictemplate_postfix_key = "<C-j>"
vim.g.sonictemplate_vim_template_dir = global.template_dir

vim.api.nvim_set_var(
  "completion_word_ignored_ft",
  {
    "LuaTree"
  }
)

vim.g.user_emmet_mode = "a"

vim.api.nvim_set_var(
  "completion_chain_complete_list",
  {
    default = {
      default = {
        {
          complete_items = {
            "lsp",
            "snippet",
            "buffers",
            "path"
          }
        },
        {mode = "<c-p>"},
        {mode = "<c-n>"}
      },
      comment = {},
      string = {}
    }
  }
)

local autocmd = {
  compilation = {
    {"BufReadPre,BufNewFile", [[* lua require'completion'.on_attach()]]}
  }
}

a.Create_augroup(autocmd)
