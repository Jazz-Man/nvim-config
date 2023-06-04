return {

  { import = "astrocommunity.git.git-blame-nvim" },
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "User AstroGitFile",
    opts = {
      diff_binaries = false, -- Show diffs for binaries
      enhanced_diff_hl = false, -- See ':h diffview-config-enhanced_diff_hl'
      use_icons = true, -- Requires nvim-web-devicons
    },
  },
  {
    "TimUntersberger/neogit",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
    },
    opts = {
      disable_signs = true,
      disable_context_highlighting = false,
      disable_commit_confirmation = false,
      integrations = { diffview = true },
    },
    event = "User AstroGitFile",
    keys = {
      { "<leader>gn", desc = "Neogit", mode = { "n" } },
      { "<leader>gnt", "<cmd>Neogit<CR>", desc = "Open Neogit Tab Page" },
      { "<leader>gnc", "<cmd>Neogit commit<CR>", desc = "Open Neogit Commit Page" },
      { "<leader>gnd", ":Neogit cwd=", desc = "Open Neogit Override CWD" },
      { "<leader>gnk", ":Neogit kind=", desc = "Open Neogit Override Kind" },
    },
  },
}
