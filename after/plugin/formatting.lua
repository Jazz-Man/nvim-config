local null_ls = prequire("null-ls")


if null_ls then

  local formatting = null_ls.builtins.formatting
  local diagnostics = null_ls.builtins.diagnostics
  local code_actions = null_ls.builtins.code_actions
  local hover = null_ls.builtins.hover

  null_ls.setup {
    debug = false,
    sources = {
      code_actions.refactoring,
      code_actions.shellcheck,
      code_actions.eslint,
      code_actions.gitrebase,
      code_actions.proselint,
      -- code_actions.refactoring
    }
  }
end
