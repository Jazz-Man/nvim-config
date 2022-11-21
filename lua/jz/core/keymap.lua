local util = require 'jz.utils'
local m = require'jz.utils.keybinding'.map
local c = require'jz.utils.keybinding'.cmd

local fmt = string.format
local autocmd = vim.api.nvim_create_autocmd

local nav_keys = { h = 'Left', j = 'Down', k = 'Up', l = 'Right' }

m:group(
  { prefix = '<leader>' }, function()

    m:nmap():k('e'):desc('NvimTree: Open File manager')
      :c(c:cmd('NvimTreeToggle'))

    -- Copy/Paste clipboard
    m:nmap():k('y'):c('"+y')
    m:nmap():k('p'):c('"+p')
    m:nmap():k('P'):c('"+P')

    -- Quickly insert an empty new line without entering insert mode
    m:nmap():k('o'):c('o<Esc>')
    m:nmap():k('O'):c('O<Esc>')

    m:nmap():k('t'):c(c:cmd('TroubleToggle'))

    local terminal_keys = { h = 'horizontal', v = 'vertical' }

    for t_key, t_direction in pairs(terminal_keys) do

      local cms_desc = fmt('toggle in terminal %s mode', t_direction)

      m:nmap():k(t_key):desc(cms_desc):c(
        c:lua(
          'nvterm.terminal', fmt('new("%s")', t_direction)
        )
      )
    end
  end
)

m:group(
  {
    ft = {

      'qf',
      'help',
      'man',
      'floaterm',
      'lspinfo',
      'lsp-installer',
      'null-ls-info'

    }
  }, function( args ) m:nnoremap():buffer(args.buf):k('q'):c(c:cmd('close')) end
)

m:group(
  { prefix = '<Bslash>' }, function()

    -- Place last yank
    m:nmap():k('p'):c('"0p')

    -- Delete without yank
    m:nmap():k('x'):c('"_x')
    m:nmap():k('d'):c('"_d')
    m:nmap():k('c'):c('"_c')
  end
)

m:group(
  { desc = 'Save File' }, function()

    m:nnoremap():desc('Shortcut'):k('<C-S>'):c(c:cmd('update'))
    m:inoremap():desc('Shortcut (I)'):k('<C-S>'):c('<esc><cmd>update<cr>gi')
  end
)

m:nmap():desc('Run vim help for current line'):k('vK'):c(
  [[<C-\><C-N>:help <C-R><C-W><CR>]]
)
m:xmap():desc('copy selection to clipboard'):k('Y'):c('"+y')

m:nmap():desc('copy entire file contents'):k('yY'):c(
  function() util.preserve('norm ggVG"+y') end
)

-- " manage windows
-- "       [count]<c-w>s and [count]<c-w>v create a [count]-sized split
-- "       [count]<c-w>| and [count]<c-w>_ resize the current window
-- " user recommendation:
-- "       <c-w>eip
-- " available:
-- "       <c-w><space>{motion}
-- "       <c-_> (<c-->)

for key, _ in pairs(nav_keys) do

  m:mode({ 'n', 'i', 't' }):k(fmt('<M-%s>', key)):c(
    fmt(
      [[<C-\><C-N><C-w><C-%s>]], key
    )
  )

end

-- m:nmap():desc('Quick clouse'):k('q'):c(c:cmd('q'))
m:group(
  { desc = 'Indent' }, function()

    m:vnoremap():desc('Indent'):k([[>]]):c([[>gv]])
    m:vnoremap():desc('De-Indent'):k([[<]]):c([[<gv]])
  end
)

m:group(
  { desc = 'Duplicate' }, function()
    m:nnoremap():desc('line downwards'):k('<C-d>'):c(c:cmd('copy.'))
    m:vnoremap():desc('selection downwards'):k('<C-d>'):c(c:cmd('copy.'))

  end
)

m:nmap():desc('Go to file under cursor (new tab)'):k([[gF]]):c([[<C-w>gf]])

-- emacs-style motion & editing in insert mode
m:group(
  { desc = 'Edit' }, function()

    m:inoremap():desc('Goto beginning of line'):k('<C-a>'):c('<Home>')
    m:inoremap():desc('Goto end of line'):k('<C-e>'):c('<End>')
    m:inoremap():desc('Goto char backward'):k('<C-b>'):c('<Left>')
    m:inoremap():desc('Goto char forward'):k('<C-f>'):c('<Right>')
    m:inoremap():desc('Goto word backward'):k('<M-b>'):c('<S-Left>')
    m:inoremap():desc('Goto word forward'):k('<M-f>'):c('<S-Right>')
    m:inoremap():desc('Kill char forward'):k('<C-d>'):c('<Delete>')
    m:inoremap():desc('Kill word forward'):k('<M-d>'):c('<C-o>de')
    m:inoremap():desc('Kill word backward'):k('<M-Backspace>'):c('<C-o>dB')
    m:inoremap():desc('Kill to end of line'):k('<C-k>'):c('<C-o>D')

    for key, direction in pairs(nav_keys) do
      m:inoremap():desc(fmt('Move to %s', direction)):k(fmt('<M-%s>', key)):c(
        fmt(
          '<%s>', direction
        )
      )
    end

    m:inoremap():k([[<M-a>]]):c([[<C-o>_]])

  end
)

m:group(
  { prefix = 's', desc = 'Split' }, function()

    m:nnoremap():desc('left above'):k('h'):c(c:cmd('leftabove vsplit'))
    m:nnoremap():desc('below right'):k('j'):c(c:cmd('belowright split'))
    m:nnoremap():desc('above left'):k('k'):c(c:cmd('aboveleft split'))
    m:nnoremap():desc('right below'):k('l'):c(c:cmd('rightbelow vsplit'))

  end
)

autocmd(
  'UIEnter', {
    callback = function()

      --- manage tabs
      m:nmap():k('<M-t>'):c(c:cmd('tab split'))
      m:nmap():k('ZT'):c(c:cmd('tabclose'))

      m:group(
        { desc = 'Buffer' }, function()

          m:nnoremap():desc('Next'):k('<tab>'):c(c:cmd('bnext'))
          m:nnoremap():desc('Prev'):k('<s-tab>'):c(c:cmd('bprevious'))
          m:nnoremap():desc('Pin Buffer'):k('<tab>p')
            :c(c:cmd('BufferLineTogglePin'))

          m:nnoremap():desc('Move Next'):k('<tab>l')
            :c(c:cmd('BufferLineMoveNext'))
          m:nnoremap():desc('Move Prev'):k('<tab>h')
            :c(c:cmd('BufferLineMovePrev'))

          m:nnoremap():desc('Switching to the previously edited file')
            :k('<tab>e'):c(
              c:cmd(
                [[edit#]]
              )
            )

          for bufn = 1, 9 do
            local desc = fmt('Go To Buffer %s', bufn)
            m:nnoremap():desc(desc):k(fmt('<tab>%d', bufn)):c(
              c:cmd(
                fmt(
                  'buffer %d', bufn
                )
              )
            )
          end

        end
      )

      ---- Tabs
      -- Navigate tabs
      -- Go to a tab by index; If it doesn't exist, create a new tab
      local function tabnm( n )
        return function()
          if vim.api.nvim_tabpage_is_valid(n) then
            vim.cmd('tabn ' .. n)
          else
            vim.cmd('$tabnew')
          end
        end
      end

      m:group(
        { desc = 'Goto tab' }, function()

          for tab, value in ipairs({ 1, 2, 3, 4, 5, 6, 7, 8, 9, 0 }) do
            m:nnoremap():desc(value):k(fmt([[<M-%s>]], value)):c(tabnm(tab))
          end
        end
      )
      m:group(
        { desc = 'Move tab' }, function()

          m:nnoremap():desc('right'):k([[<M-">]]):c(c:cmd('+tabm'))
          m:nnoremap():desc('left'):k([[<M-:>]]):c(c:cmd('-tabm'))
        end
      )

      m:group(
        { desc = 'Tabs Goto' }, function()

          m:nnoremap():desc('next'):k([[<M-'>]]):c(c:cmd('tabn'))
          m:nnoremap():desc('prev'):k([[<M-;>]]):c(c:cmd('tabp'))

          m:tnoremap():desc('next'):k([[<M-'>]]):c([[<C-\><C-n>:tabn<Cr>]])
          m:tnoremap():desc('prev'):k([[<M-;>]]):c([[<C-\><C-n>:tabp<Cr>]])
          m:nnoremap():desc('last accessed'):k([[<M-S-a>]]):c(
            c:cmd(
              [[execute "wincmd g\<Tab>"]]
            )
          )

        end
      )

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
        m:vmap():k(map_key):c(c:plug(fmt('GoVSM%s', value)))
      end

    end,
    desc = 'booperlv nvim-gomove'

  }
)

autocmd(
  'BufWinEnter', {
    callback = function()

      m:nmap():k('<leader>df'):c(
        c:treesitter_textobjects(
          'lsp_interop', 'peek_definition_code("@function.outer")'
        )
      )
    end
  }
)

-- Comments

m:nmap():k('<C-_>'):c(c:comment_call('current_linewise') .. 'g@$')
m:nmap():k([[<C-\>]]):c(c:comment_call('current_blockwise') .. 'g@$')
m:nmap():k('<leader>cc'):c(c:comment_call('linewise') .. 'g@')

m:xmap():k('<C-_>'):c(c:comment_toggle('linewise'))
m:xmap():k([[<C-\>]]):c(c:comment_toggle('blockwise'))

m:nmap():k('<leader>co'):c(c:comment('insert_linewise_above()'))
m:nmap():k('<leader>ca'):c(c:comment('insert_linewise_eol()'))

m:group(
  { noremap = true, prefix = '<leader>', desc = 'LSP' }, function()

    m:nmap():desc('Show LSP information'):k('li'):c(c:cmd('LspInfo'))
    m:nmap():desc('Show LspInstallInfo information'):k('lI'):c(
      c:cmd(
        'LspInstallInfo'
      )
    )
    m:nmap():desc('Show NullLsInfo information'):k('ln'):c(c:cmd('NullLsInfo'))
    m:nmap():desc('Restart LSP'):k('lr'):c(c:cmd('LspRestart'))
    m:nmap():desc('Start LSP'):k('ls'):c(c:cmd('LspStart'))
    m:nmap():desc('Stop LSP'):k('lS'):c(c:cmd('LspStop'))

  end
)

autocmd(
  'LspAttach', {
    callback = function( args )
      local client = vim.lsp.get_client_by_id(args.data.client_id)

      m:group(
        {
          buffer = args.buf,
          noremap = true,
          prefix = '<localleader>',
          desc = 'LSP'
        }, function()

          --- LSP-Goto

          m:nmap():desc('Goto declaration'):k('gD'):c(vim.lsp.buf.declaration)

          m:nmap():desc('Goto definition'):k('gd'):c(vim.lsp.buf.definition)
          m:nmap():desc('Goto implementation'):k('gi')
            :c(vim.lsp.buf.implementation)

          m:nmap():desc('Goto type definition'):k('gt'):c(
            vim.lsp.buf.type_definition
          )

          m:nmap():desc('Goto references'):k('gr'):c(vim.lsp.buf.references)

          --- LSP-Workspace
          m:nmap():desc('Add workspace folder'):k('wa'):c(
            vim.lsp.buf.add_workspace_folder
          )
          m:nmap():desc('Rm workspace folder'):k('wr'):c(
            vim.lsp.buf.remove_workspace_folder
          )
          m:nmap():desc('List workspace folders'):k('wl'):c(
            function() dump(vim.lsp.buf.list_workspace_folders()) end
          )

          m:nmap():desc('Code action'):k('ca'):c(vim.lsp.buf.code_action)
          --- m:vmap():desc('Code action (range)'):k('ca'):c(vim.lsp.buf.range_code_action)

          m:nmap():desc('Rename'):k('R'):c(vim.lsp.buf.rename)

          m:nmap():desc('Incoming Calls'):k('ci'):c(vim.lsp.buf.incoming_calls)
          m:nmap():desc('Outgoing Calls'):k('co'):c(vim.lsp.buf.outgoing_calls)

          m:nmap():desc('Hover'):k('ho'):c(vim.lsp.buf.hover)

          m:nmap():desc('Signature help'):k('hs'):c(vim.lsp.buf.signature_help)

          if client.server_capabilities.documentFormattingProvider then
            m:nmap():k('f'):c(vim.lsp.buf.format)
          end
        end
      )
    end,

    desc = 'Lsp key mapping'
  }
)
