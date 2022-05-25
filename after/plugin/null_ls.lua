local null_ls = require 'null-ls'
local on_attach = require 'jz.lsp.on_attach'


local null_fmt = null_ls.builtins.formatting
local null_diag = null_ls.builtins.diagnostics
local null_act = null_ls.builtins.code_actions

null_ls.setup {
  debug = false,
  on_attach = on_attach.on_attach,
  sources = {
    null_act.refactoring,
    null_act.shellcheck,
    null_act.eslint,
    null_act.gitrebase,
    null_act.proselint,
    null_fmt.prettierd,
    null_fmt.lua_format,
    null_fmt.trim_whitespace,
    null_fmt.djlint,
    null_fmt.eslint,
    null_fmt.eslint_d,
    null_fmt.shfmt,
    null_fmt.sqlfluff,
    null_fmt.jq,
    null_fmt.phpcsfixer,
    null_diag.actionlint,
    null_diag.ansiblelint,
    null_diag.codespell,
    null_diag.curlylint,
    null_diag.djlint,
    null_diag.eslint_d,
    null_diag.eslint,
    null_diag.gitlint,
    null_diag.luacheck,
    null_diag.php,
    null_diag.phpmd,
    null_diag.phpstan,
    null_diag.psalm,
    null_diag.sqlfluff,
    null_diag.trail_space,
    null_diag.tsc,
    null_diag.vint,
    null_diag.zsh,
    null_diag.yamllint
  }
}
