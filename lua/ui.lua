local lspactions = prequire('lspactions')

if lspactions then
  vim.ui.select = lspactions.select
  vim.ui.input = lspactions.input
end
