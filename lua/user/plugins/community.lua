return {

  -- Add the community repository of plugin specifications
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.completion.codeium-vim" },

  { import = "astrocommunity.pack.yaml" },
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.json" },
  { import = "astrocommunity.pack.docker" },
  { import = "astrocommunity.pack.bash" },
  { import = "astrocommunity.pack.markdown" },
  { import = "astrocommunity.pack.python" },
  { import = "astrocommunity.pack.toml" },
  { import = "astrocommunity.pack.typescript-all-in-one" },
  { import = "astrocommunity.pack.prisma" },
  { import = "astrocommunity.pack.ansible" },
  { import = "astrocommunity.pack.astro" },
  { import = "astrocommunity.pack.cmake" },
  { import = "astrocommunity.pack.cpp" },
  { import = "astrocommunity.pack.html-css" },
  { import = "astrocommunity.pack.prisma" },
  { import = "astrocommunity.pack.rust" },
  { import = "astrocommunity.pack.svelte" },

  { import = "astrocommunity.diagnostics.trouble-nvim" },
  { import = "astrocommunity.motion.nvim-spider" },
  { import = "astrocommunity.motion.vim-matchup" },

  -- add lsp plugins
  { import = "astrocommunity.lsp.lsp-lens-nvim" },
  { import = "astrocommunity.lsp.inc-rename-nvim" },
  { import = "astrocommunity.lsp.lsp-signature-nvim" },

  { import = "astrocommunity.editing-support.refactoring-nvim" },
  { import = "astrocommunity.editing-support.todo-comments-nvim" },
  { import = "astrocommunity.editing-support.yanky-nvim" },
  { import = "astrocommunity.indent.mini-indentscope" },

  { import = "astrocommunity.programming-language-support.nvim-jqx" },
  { import = "astrocommunity.programming-language-support.rest-nvim" },
}
