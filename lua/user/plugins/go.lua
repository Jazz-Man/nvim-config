local utils = require "astronvim.utils"

return {

  -- Golang support
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, "go")
      end
    end,
  },

  {
    "jay-babu/mason-null-ls.nvim",
    opts = function(_, opts)
      opts.ensure_installed = utils.list_insert_unique(
        opts.ensure_installed,
        { "gomodifytags", "gofumpt", "iferr", "impl", "goimports", "reviser" }
      )
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts) opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, "gopls") end,
  },

  {
    "leoluz/nvim-dap-go",
    ft = { "go", "gomod", "gotmpl" },
    dependencies = {
      "mfussenegger/nvim-dap",
      {
        "jay-babu/mason-nvim-dap.nvim",
        opts = function(_, opts) opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, "delve") end,
      },
    },
    opts = {},
  },

  {
    "crispgm/nvim-go",
    ft = { "go", "gomod", "gotmpl" },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      -- notify: use nvim-notify
      notify = false,
      -- auto commands
      auto_format = true,
      auto_lint = true,
      -- linters: revive, errcheck, staticcheck, golangci-lint
      linter = "revive",
      linter_flags = {},
      -- lint_prompt_style: qf (quickfix), vt (virtual text)
      lint_prompt_style = "vt",
      -- formatter: goimports, gofmt, gofumpt
      formatter = "goimports",
      -- test flags: -count=1 will disable cache
      test_flags = { "-v" },
      test_timeout = "30s",
      test_env = {},
      -- show test result with popup window
      test_popup = true,
      test_popup_auto_leave = false,
      test_popup_width = 80,
      test_popup_height = 10,
      -- test open
      test_open_cmd = "edit",
      -- struct tags
      tags_name = "json",
      tags_options = { "json=omitempty" },
      tags_transform = "snakecase",
      tags_flags = { "-skip-unexported" },
      -- quick type
      quick_type_flags = { "--just-types" },
    },
  },
}
