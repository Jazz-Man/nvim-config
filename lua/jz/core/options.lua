local opt = vim.opt -- global for let options
local wo = vim.wo -- window local
local bo = vim.bo -- buffer local
local g = vim.g -- global for let options
local fmt = string.format
local fn = vim.fn -- access vim functions

local utils = require 'jz.utils'

-- IMPROVE NEOVIM STARTUP
-- https://github.com/editorconfig/editorconfig-vim/issues/50
vim.g.loaded_python_provier = 0
vim.g.loaded_python3_provider = 0
vim.g.python_host_skip_check = 1
vim.g.python_host_prog = fmt('%s/.pyenv/shims/python2', utils.home)
vim.g.python3_host_skip_check = 1
vim.g.python3_host_prog = '/usr/bin/python3'
vim.opt.pyxversion = 3

vim.g.EditorConfig_core_mode = 'external_command'
-- https://vi.stackexchange.com/a/5318/7339
vim.g.matchparen_timeout = 20
vim.g.matchparen_insert_timeout = 20

local global_config = {
  -----------------------------------------------------------
  -- General
  -----------------------------------------------------------
  mouse = 'ar', -- Enable mouse support
  mousemodel = 'popup_setpos',
  exrc = false, -- ignore '~/.exrc'
  secure = true,
  shell = '/bin/zsh',
  clipboard = 'unnamedplus', -- Copy/paste to system clipboard
  swapfile = false, -- Don't use swapfile
  shada = { '!', '\'300', '<50', '@100', 's10', 'h' },
  textwidth = 100, -- Maximum width of text that is being inserted.

  errorbells = true,
  visualbell = true,

  -----------------------------------------------------------
  -- Encoding and File formatt
  -----------------------------------------------------------
  encoding = 'utf-8', -- String-encoding used internally and for RPC communication.
  fileencoding = 'utf-8',
  fileformats = 'unix,mac,dos',
  fileformat = 'unix',

  -----------------------------------------------------------
  -- Memory, CPU
  -----------------------------------------------------------
  hidden = true, -- Enable background buffers
  history = 2000, -- Remember N lines in history
  lazyredraw = true, -- Faster scrolling
  synmaxcol = 500, -- Max column for syntax highlight
  updatetime = 500, -- ms to wait for trigger an event
  ttimeout = true,
  timeoutlen = 500, -- Time in milliseconds to wait for a mapped sequence to complete. (default 1000)
  redrawtime = 1500, -- Time in milliseconds for redrawing the display.

  joinspaces = false, -- No double spaces with join
  -----------------------------------------------------------
  -- Neovim UI
  -----------------------------------------------------------
  splitright = true, -- Vertical split to the right
  splitbelow = true, -- Horizontal split to the bottom
  ignorecase = true, -- Ignore case letters when search
  smartcase = true, -- Ignore lowercase for the whole pattern
  termguicolors = true, -- Enable 24-bit RGB colors
  wrap = false,
  showmode = false, -- If in Insert, Replace or Visual mode put a message on the last line.
  pumblend = 17, -- Enables pseudo-transparency for the popup-menu.
  showtabline = 2, -- always show tabs
  cmdheight = 1,
  emoji = false, -- CREDIT: https://www.youtube.com/watch?v=F91VWOelFNE
  title = true,
  titlestring = fmt('%s:%s', fn.getpid(), fn.getcwd()),

  syntax = 'ON', -- str:  Allow syntax highlighting
  cursorline = true,
  -- guicursor = {
  --   'n-v:block',
  --   'i-c-ci-ve:ver25',
  --   'r-cr:hor20',
  --   'o:hor50',
  --   'i:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor',
  --   'sm:block-blinkwait175-blinkoff150-blinkon175'
  -- },
  --
  -- disable tilde on end of buffer: https://github.com/neovim/neovim/pull/8546#issuecomment-643643758
  fillchars = { eob = '~' },

  -----------------------------------------------------------
  -- Fold config
  -----------------------------------------------------------

  foldlevelstart = 99,

  -----------------------------------------------------------
  -- Dirs
  -----------------------------------------------------------
  directory = utils.dir_path('swag'), -- List of directory names for the swap file, separated with commas.
  undodir = utils.dir_path('undo'),
  undofile = true,
  backupdir = utils.dir_path('backup'),
  viewdir = utils.dir_path('view'),
  backupskip = {
    '/tmp/*',
    '$TMPDIR/*',
    '$TMP/*',
    '$TEMP/*',
    '*/shm/*',
    '/private/var/*',
    '.vault.vim'
  },

  suffixes = opt.suffixes + {
    '.aux',
    '.log',
    '.dvi',
    '.bbl',
    '.blg',
    '.brf',
    '.cb',
    '.ind',
    '.idx',
    '.ilg',
    '.inx',
    '.out',
    '.toc',
    '.o',
    '.obj',
    '.dll',
    '.class',
    '.pyc',
    '.ipynb',
    '.so',
    '.swp',
    '.zip',
    '.exe',
    '.jar',
    '.gz'
  },

  -----------------------------------------------------------
  -- Search
  -----------------------------------------------------------
  inccommand = 'nosplit', -- When nonempty, shows the effects of :substitute, :smagic, and :snomagic as you type
  showmatch = true,
  magic = true,

  virtualedit = 'block',

  wildignorecase = true,
  wildignore = {
    '.git',
    '.hg',
    '.svn',
    '*.pyc',
    '*.o',
    '*.out',
    '*.jpg',
    '*.jpeg',
    '*.png',
    '*.gif',
    '*.zip',
    '**/tmp/**',
    '*.DS_Store',
    '**/node_modules/**',
    '**/bower_modules/**'
  },

  -- Disable backups
  backup = false,
  writebackup = false,

  shiftround = true, -- Round indent
  infercase = true,
  wrapscan = true,
  complete = '.,w,b,k',

  breakat = [[\ \	;:,!?]],
  startofline = false,
  whichwrap = opt.whichwrap:append '<>[]hl',
  iskeyword = opt.iskeyword:append '-',

  switchbuf = 'useopen',
  diffopt = {
    'internal',
    'filler',
    'closeoff',
    'hiddenoff',
    'algorithm:patience'
  },
  jumpoptions = 'stack',
  scrolloff = 2,
  sidescrolloff = 5,
  list = true,

  winwidth = 30,
  winminwidth = 10,

  pumheight = 15,
  helpheight = 12,
  previewheight = 12,
  showcmd = true, -- Show (partial) command in the last line of the screen.
  cmdwinheight = 5,

  equalalways = true,

  display = 'msgsep',
  showbreak = '↳  ',

  autoindent = true, -- Copy indent from current line when starting a new line

  -----------------------------------------------------------
  -- Completion
  -----------------------------------------------------------
  wildmode = 'full',
  dictionary = opt.dictionary + { '/usr/share/dict/words' }

}

local window_config = {
  -----------------------------------------------------------
  -- Neovim UI
  -----------------------------------------------------------
  number = true, -- Show line number
  numberwidth = 2,
  relativenumber = false,
  linebreak = true, -- Stop words being broken on wrap
  breakindentopt = 'shift:2,min:20',
  colorcolumn = '120',
  signcolumn = 'yes:1' -- When and how to draw the signcolumn.

}

local buffer_options = {

  expandtab = true, -- Use spaces instead of tabs
  softtabstop = -1,
  tabstop = 2, -- 1 tab == 2 spaces
  shiftwidth = 2,
  smartindent = true

}

opt.completeopt:append { 'noinsert', 'menuone', 'noselect', 'preview' }
opt.shortmess:append('c')

opt.formatoptions = 'l'
opt.formatoptions = opt.formatoptions - 'a' -- Auto formatting is BAD.
    - 't' -- Don't auto format my code. I got linters for that.
    + 'c' -- In general, I like it when comments respect textwidth
    + 'q' -- Allow formatting comments w/ gq
    - 'o' -- O and o, don't continue comments
    + 'r' -- But do continue when pressing enter.
    + 'n' -- Indent past the formatlistpat, not underneath it.
    + 'j' -- Auto-remove comments if possible.
    - '2' -- I'm not in gradeschool anymore

for name, value in pairs(global_config) do opt[name] = value end

for name, value in pairs(window_config) do wo[name] = value end

for name, value in pairs(buffer_options) do bo[name] = value end

g.vimsyn_embed = 'lPr'
g.nojoinspaces = true

-- disable builtins plugins
local disabled_built_ins = {
  '2html_plugin',
  'getscript',
  'getscriptPlugin',
  'gzip',
  'logipat',
  'matchit',
  'netrw',
  'netrwFileHandlers',
  'loaded_remote_plugins',
  'loaded_tutor_mode_plugin',
  'netrwPlugin',
  'netrwSettings',
  'rrhelper',
  'spellfile_plugin',
  'tar',
  'tarPlugin',
  'vimball',
  'vimballPlugin',
  'zip',
  'zipPlugin',
  'matchparen' -- matchparen.nvim disables the default
}

for _, plugin in pairs(disabled_built_ins) do vim.g['loaded_' .. plugin] = 1 end

vim.g.did_load_filetypes = 1

-- Disable providers

local providers = {
  'perl',
  'ruby'
  -- 'python'
}

for _, provider in pairs(providers) do g[fmt('loaded_%s_provider', provider)] = 0
end

-- Map leader to <space>
vim.api.nvim_set_keymap(
  '', '<Space>', '<Nop>', { noremap = true, silent = true }
)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

if fn.executable('rg') then
  -- if ripgrep installed, use that as a grepper
  vim.opt.grepprg = 'rg --vimgrep --no-heading --smart-case'
  vim.opt.grepformat = '%f:%l:%c:%m,%f:%l:%m'
end
