return {
  settings = {
    Lua = {
      format = { enable = true },
      diagnostics = {
        enable = true,
        libraryFiles = "Enable",
        globals = { "vim", "nvim", "RELOAD" },
      },
      codeLens = {
        enable = true,
      },
      completion = {
        autoRequired = true,
        displayContext = 1,
        enable = true,
        requireSeparator = ".",
      },
      hint = {
        arrayIndex = "Auto",
        enable = true,
        setType = true,
      },
      runtime = {
        builtin = "enable",
      },
    },
  },
}
