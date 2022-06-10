---@module "jz.utils"
local util = require 'jz.utils'

util.nmap('<leader><leader>x', ':call rd#save_and_exec()<CR>')

--- Comments
util.nmap(
  '<leader>/', '<CMD>lua require("Comment.api").toggle_current_linewise()<CR>'
)
util.vmap(
  '<leader>/',
  '<ESC><cmd>lua require(\'Comment.api\').toggle_linewise_op(vim.fn.visualmode())<CR>'
)

-- toggle in terminal mode

util.map(
  { 't', 'n' }, '<A-i>',
  function() require('nvterm.terminal').toggle 'float' end
)

util.map(
  { 't', 'n' }, '<A-h>',
  function() require('nvterm.terminal').toggle 'horizontal' end
)

util.map(
  { 't', 'n' }, '<A-v>',
  function() require('nvterm.terminal').toggle 'vertical' end
)

util.nmap(
  '<leader>h', function() require('nvterm.terminal').new 'horizontal' end
)

util.nmap('<leader>v', function() require('nvterm.terminal').new 'vertical' end)

util.nmap('<leader>t', '<cmd>Trouble<cr>')
util.nmap('<leader>tw', '<cmd>Trouble workspace_diagnostics<cr>')
util.nmap('<leader>td', '<cmd>Trouble document_diagnostics<cr>')
util.nmap('<leader>tl', '<cmd>Trouble loclist<cr>')
util.nmap('<leader>tq', '<cmd>Trouble quickfix<cr>')
util.nmap('<leader>tr', '<cmd>Trouble lsp_references<cr>')

-- nvim-tree
util.nmap('<leader>e', '<cmd>NvimTreeToggle<cr>')
util.nmap('<leader>ef', '<cmd>NvimTreeFindFile<cr>')
util.nmap('<leader>er', '<cmd>NvimTreeRefresh<cr>')

-- packer.nvim
util.nmap('<leader>ps', '<cmd>PackerSync<cr>')
util.nmap('<leader>pu', '<cmd>PackerUpdate<cr>')
util.nmap('<leader>pi', '<cmd>PackerInstall<cr>')
util.nmap('<leader>pc', '<cmd>PackerClean<cr>')
