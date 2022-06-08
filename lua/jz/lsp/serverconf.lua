local cssLintSettings = {
    compatibleVendorPrefixes = 'ignore',
    vendorPrefix = 'warning',
    duplicateProperties = 'ignore',
    emptyRules = 'ignore',
    importStatement = 'ignore'
}

local cssLSSetting = {validate = true, lint = cssLintSettings}

local servers = {
    cssls = {
        filetypes = {'css', 'scss', 'less', 'sass'},
        settings = {
            css = cssLSSetting,
            scss = cssLSSetting,
            less = cssLSSetting,
            sass = cssLSSetting
        }
    },
}

return servers
