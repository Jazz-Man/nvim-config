---@module "jz.utils"
local util = require 'jz.utils'

local fn = vim.fn
local cmd = vim.api.nvim_command
local fmt = string.format
local autocmd = vim.api.nvim_create_autocmd
local user_command = vim.api.nvim_create_user_command

local nav_keys = { h = 'Left', j = 'Down', k = 'Up', l = 'Right' }

-- toggle in terminal mode
util.nmap(
  '<leader>h', function() require('nvterm.terminal').new 'horizontal' end
)

util.nmap('<leader>v', function() require('nvterm.terminal').new 'vertical' end)

-- util.nmap('<leader>t', '<cmd>Trouble<cr>')
util.nmap('<leader>tw', '<cmd>Trouble workspace_diagnostics<cr>')
util.nmap('<leader>td', '<cmd>Trouble document_diagnostics<cr>')
util.nmap('<leader>tl', '<cmd>Trouble loclist<cr>')
util.nmap('<leader>tq', '<cmd>Trouble quickfix<cr>')
util.nmap('<leader>tr', '<cmd>Trouble lsp_references<cr>')

-- nvim-tree
util.nmap('<leader>e', '<cmd>NvimTreeToggle<cr>')
util.nmap('<leader>ef', '<cmd>NvimTreeFindFile<cr>')
util.nmap('<leader>er', '<cmd>NvimTreeRefresh<cr>')

-- Place last yank
util.nmap('<Bslash>p', '"0p')

-- Delete without yank
util.nmap('<Bslash>x', '"_x')
util.nmap('<Bslash>d', '"_d')
util.nmap('<Bslash>c', '"_c')

-- Increment/decrement
-- util.nmap('+', '<C-a>')

-- Copy/Paste clipboarw
util.nmap('<Leader>y', '"+y')
util.nmap('<Leader>p', '"+p')
util.nmap('<Leader>P', '"+P')

-- Quickly insert an empty new line without entering insert mode
util.nmap('<Leader>o', 'o<Esc>')
util.nmap('<Leader>O', 'O<Esc>')

-- Shortcut for saving the file
util.nmap('<C-S>', ':update<cr>')

util.imap('<C-S>', '<Esc>:update<cr>gi')
util.nmap('vK', [[<C-\><C-N>:help <C-R><C-W><CR>]]) --- Run vim help for current line

-- copy selection to gui-clipboard
util.xmap('Y', '"+y')

---copy entire file contents (to gui-clipboard if available)
util.nmap('yY', function() util.preserve('norm ggVG"+y') end)

util.nmap('z=', ':setlocal spell<CR>z=')

-- " manage windows
-- "       [count]<c-w>s and [count]<c-w>v create a [count]-sized split
-- "       [count]<c-w>| and [count]<c-w>_ resize the current window
-- " user recommendation:
-- "       <c-w>eip
-- " available:
-- "       <c-w><space>{motion}
-- "       <c-_> (<c-->)

for key, _ in pairs(nav_keys) do

  util.map(
    { 'n', 'i', 't' }, fmt('<M-%s>', key), fmt('<C-\\><C-N><C-w><C-%s>', key)
  )
end

--- Quick clouse
util.nmap('q', ':q<cr>')

util.nmap('sh', ':leftabove vsplit<CR>')
util.nmap('sj', ':belowright split<CR>')
util.nmap('sk', ':aboveleft split<CR>')
util.nmap('sl', ':rightbelow vsplit<CR>')

autocmd(
  'UIEnter', {
  callback = function()

    --- manage tabs
    util.nmap('<M-t>', ':tab split<cr>')
    util.nmap('ZT', ':tabclose<cr>')

    util.nmap('<tab>', '<cmd>BufferLineCycleNext<cr>')
    util.nmap('<s-tab>', '<cmd>BufferLineCyclePrev<cr>')

  end
}
)

autocmd(
  { 'CursorMoved', 'CursorMovedI' }, {
  callback = function()
    local ok, _ = pcall(require, 'gomove')
    if not ok then return end

    for key, value in pairs(nav_keys) do
      local map_key = fmt('<M-%s>', key)
      util.vmap(map_key, fmt('<Plug>GoVSM%s', value))
    end

  end,
  desc = 'booperlv nvim-gomove'

}
)

autocmd(
  'BufWinEnter', {
  callback = function(args)
    local ok, _ = pcall(require, 'nvim-treesitter')
    if not ok then return end

    ---@param module string
    ---@param option string
    ---@return string
    local function api(module, option)
      return fmt('<cmd>lua require"nvim-treesitter.%s".%s<cr>', module, option)
    end

    ---@param module string
    ---@param options string
    ---@return string
    local function textobjects(module, options)
      return api(fmt('textobjects.%s', module), options)
    end

    ---@param module string
    ---@param options string
    ---@return string
    local function refactor(module, options)

      return api(fmt('refactor.%s', module), options)
    end

    -- local options = { buffer = args.buf }

    util.nmap(
      '<leader>df',
      textobjects('lsp_interop', 'peek_definition_code("@function.outer")')
    )
  end
}
)

autocmd(
  'BufWinEnter', {
  callback = function(args)

    local ok, _ = pcall(require, 'Comment.api')

    if not ok then return end

    ---@param option string
    ---@return string
    local api = function(option)
      return fmt('<cmd>lua require"Comment.api".%s<cr>', option)
    end

    local call = function(toggle)
      return api(fmt('call("toggle_%s_op")', toggle))
    end

    local toggle = function(toggle)
      local toggle_cmd = fmt('toggle_%s_op(vim.fn.visualmode())', toggle)

      return fmt('<esc>%s', api(toggle_cmd))
    end

    local options = { buffer = args.buf }

    util.nmap('<C-_>', call('current_linewise') .. 'g@$', options)
    util.nmap([[<C-\>]], call('current_blockwise') .. 'g@$', options)
    util.nmap('<leader>cc', call('linewise') .. 'g@', options)

    util.xmap('<C-_>', toggle('linewise'), options)
    util.xmap([[<C-\>]], toggle('blockwise'), options)

    util.nmap('<leader>co', api('insert_linewise_above()'), options)
    util.nmap('<leader>ca', api('insert_linewise_eol()'), options)

  end,
  desc = 'numToStr Comment.nvim'
}
)

-- autocmd(
--   'LspAttach', {
--   callback = function(args)
--     local client = vim.lsp.get_client_by_id(args.data.client_id)

--     local bufnr = args.buf

--   end,

--   desc = 'Lsp key mapping'
-- }
-- )

user_command(
  'TroubleEnter', function()

    -- register keymaps for splitting windows and then closing windows
    local fooModeKeymaps = {
      -- zf = 'split',
      -- zfo = 'vsplit',
      -- zfc = 'q',
      t = ':Trouble'
    }

    util.mode_enter('Trouble', fooModeKeymaps)

  end, { force = false }
)
