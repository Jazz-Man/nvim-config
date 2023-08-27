return {
  "jose-elias-alvarez/null-ls.nvim",

  opts = function(_, config)
    local null_ls = require "null-ls"
    local formatting = null_ls.builtins.formatting
    local diagnostics = null_ls.builtins.diagnostics
    local code_actions = null_ls.builtins.code_actions

    config.debug = false
    config.log_level = "warn"

    config.sources = {
      code_actions.refactoring,
      code_actions.shellcheck,
      code_actions.eslint_d.with { prefer_local = "node_modules/.bin" },
      code_actions.gitsigns,
      code_actions.gitrebase,

      diagnostics.codespell,
      diagnostics.yamllint,
      diagnostics.trail_space,
      diagnostics.shellcheck,
      diagnostics.sqlfluff,
      diagnostics.php,
      diagnostics.revive,
      diagnostics.psalm.with {
        condition = function(nl_utils) return nl_utils.root_has_file { "psalm.xml" } end,
      },
      diagnostics.phpstan.with {
        condition = function(nl_utils) return nl_utils.root_has_file { "phpstan.neon", "phpstan.neon.dist" } end,
      },
      diagnostics.phpmd.with {
        prefer_local = "vendor/bin",
        extra_args = { "phpmd.ruleset.xml", "--baseline-file", "phpmd.baseline.xml" },
        condition = function(nl_utils) return nl_utils.root_has_file { "phpmd.ruleset.xml" } end,
      },
      formatting.shfmt,
      formatting.jq,
      formatting.sqlfluff,
      formatting.phpcsfixer.with {

        condition = function(nl_utils) return nl_utils.root_has_file { ".php-cs-fixer.php" } end,
      },
      -- formatting.phpcbf.with {
      --   condition = function(nl_utils) return nl_utils.root_has_file { "phpcs.xml" } end,
      -- },
      formatting.prettier,
      formatting.codespell,
    }
    return config
  end,
}
