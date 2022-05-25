local prefix = vim.diagnostic and "DiagnosticSign" or "LspDiagnosticsSign"


local signs = {
  {
    name = ("%sHint"):format(prefix),
    text = ''
  },
  {
    -- LspDiagnosticsSign has "Information", not "Info"
    name = ("%s%s"):format(prefix, vim.diagnostic and "Info" or "Information"),
    text = ''
    -- text = '',
    -- text = '',
  },
  {
    -- LspDiagnosticsSign has "Warning", not "Warn"
    name = ("%s%s"):format(prefix, vim.diagnostic and "Warn" or "Warning"),
    text = '',
    -- text = ''
  },
  {
    name = ("%sError"):format(prefix),
    text = ''
    -- text = ''
  },
}


-- set sign highlights to same name as sign
-- i.e. 'DiagnosticWarn' gets highlighted with hl-DiagnosticWarn
for i = 1, #signs do
  signs[i].texthl = signs[i].name
end


-- define all signs at once
vim.fn.sign_define(signs)


if vim.diagnostic then

  vim.diagnostic.config({
    underline = true,
    update_in_insert = false,
    virtual_text = {
      spacing = 4,
      source = 'always',
      severity = {
        min = vim.diagnostic.severity.HINT,
      },
      -- format = function(diagnostic)
      -- if diagnostic.severity == vim.diagnostic.severity.ERROR then
      --   return string.format('E: %s', diagnostic.message)
      -- end
      -- return ("%s"):format(diagnostic.message)
      -- end,
    },
    signs = true,
    severity_sort = true,
    float = {
      show_header = false,
      source = 'always',
      border = 'rounded',
    },
  })
end
