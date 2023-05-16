local css_setting = {
  validate = true,
  lint = {
    compatibleVendorPrefixes = "ignore",
    vendorPrefix = "warning",
    duplicateProperties = "ignore",
    emptyRules = "ignore",
    importStatement = "ignore",
  },
}

return {
  filetypes = { "css", "scss", "sass", "less" },
  settings = { css = css_setting, scss = css_setting, sass = css_setting, less = css_setting },
}
