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
    yamlls = {
        settings = {
            yaml = {
                completion = true,
                hover = true,
                format = {
                    enable = true,
                    bracketSpacing = true,
                    printWidth = 80,
                    proseWrap = 'preserve',
                    singleQuote = true
                },
                schemaStore = {enable = true}
            }
        }
    },
}

return servers
