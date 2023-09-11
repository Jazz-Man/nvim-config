return {

  {
    import = "astrocommunity.git.git-blame-nvim",
  },
  { import = "astrocommunity.git.neogit" },
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "User AstroGitFile",
    opts = {
      diff_binaries = false, -- Show diffs for binaries
      enhanced_diff_hl = true, -- See ':h diffview-config-enhanced_diff_hl'
      use_icons = true, -- Requires nvim-web-devicons
    },
  },
}
