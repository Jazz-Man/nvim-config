return {
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
        unreachable = false,
        fieldalignment = true,
        nilness = true,
        shadow = true,
        unusedwrite = true,
        useany = true,
      },
      codelenses = {
        generate = true,
        gc_details = true,
        test = true,
        tidy = true,
        upgrade_dependency = true,
        regenerate_cgo = true,
      },
      annotations = {
        bounds = true,
        escape = true,
        inline = true,
        ["nil"] = true,
      },
      staticcheck = true,
      usePlaceholders = true,
      completeUnimported = true,
      hoverKind = "Structured",
      experimentalUseInvalidMetadata = true,
      experimentalPostfixCompletions = true,
    },
  },
}
