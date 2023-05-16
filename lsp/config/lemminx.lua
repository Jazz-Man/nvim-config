return {
  settings = {
    xml = {
      useCache = true,
      trace = { server = "verbose" },
      format = {
        enabled = true,
        splitAttributes = true,
        formatComments = true,
        spaceBeforeEmptyCloseTag = true,
      },
      validation = {
        noGrammar = "hint",
        schema = true,
        enabled = true,
        resolveExternalEntities = true,
      },
    },
  },
}
