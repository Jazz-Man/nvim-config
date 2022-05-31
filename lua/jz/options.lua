local utils = require 'jz.utils'

local global_config = {
  -----------------------------------------------------------
  -- General
  -----------------------------------------------------------
  mouse = "ar", -- Enable mouse support
  mousemodel = "popup_setpos",

  exrc = false, -- ignore '~/.exrc'
  secure = true,

  ruler = false,
  clipboard = "unnamedplus", -- Copy/paste to system clipboard
  swapfile = false, -- Don't use swapfile
  shada = {
    "!",
    "'300",
    "<50",
    "@100",
    "s10",
    "h"
  },
  textwidth = 100, -- Maximum width of text that is being inserted.

  errorbells = true,
  visualbell = true,

  -----------------------------------------------------------
  -- Encoding and File formatt
  -----------------------------------------------------------
  encoding = "utf-8", -- String-encoding used internally and for RPC communication.
  fileencoding = "utf-8",
  fileformats = "unix,mac,dos",
  fileformat = "unix",

  -----------------------------------------------------------
  -- Memory, CPU
  -----------------------------------------------------------
  hidden = true, -- Enable background buffers
  history = 2000, -- Remember N lines in history
  lazyredraw = true, -- Faster scrolling
  synmaxcol = 500, -- Max column for syntax highlight
  updatetime = 500, -- ms to wait for trigger an event
  timeout = true,
  ttimeout = true,
  timeoutlen = 500, -- Time in milliseconds to wait for a mapped sequence to complete. (default 1000)
  -- ttimeoutlen = 10,
  redrawtime = 1500, -- Time in milliseconds for redrawing the display.

  -----------------------------------------------------------
  -- Tabs, indent
  -----------------------------------------------------------
  expandtab = true, -- Use spaces instead of tabs
  shiftwidth = 2, -- Shift 2 spaces when tab
  tabstop = 2, -- 1 tab == 2 spaces
  softtabstop = -1,
  smarttab = true,
  smartindent = true, -- Autoindent new lines

  -----------------------------------------------------------
  -- Neovim UI
  -----------------------------------------------------------
  splitright = true, -- Vertical split to the right
  splitbelow = true, -- Horizontal split to the bottom
  ignorecase = true, -- Ignore case letters when search
  smartcase = true, -- Ignore lowercase for the whole pattern
  termguicolors = true, -- Enable 24-bit RGB colors
  -- laststatus = 3, -- Set global statusline
  wrap = false,
  showmode = false, -- If in Insert, Replace or Visual mode put a message on the last line.
  pumblend = 17, -- Enables pseudo-transparency for the popup-menu.
  showtabline = 2, -- always show tabs
  cmdheight = 1,
  title = true,
  cursorline = true,

  -- disable tilde on end of buffer: https://github.com/neovim/neovim/pull/8546#issuecomment-643643758
  fillchars = { eob = " " },


  -----------------------------------------------------------
  -- Fold config
  -----------------------------------------------------------

  foldlevelstart = 99,

  -----------------------------------------------------------
  -- Dirs
  -----------------------------------------------------------
  directory = utils.dir_path("swag"), -- List of directory names for the swap file, separated with commas.
  undodir = utils.dir_path("undo"),
  undofile = true,
  backupdir = utils.dir_path('backup'),
  viewdir = utils.dir_path("view"),
  backupskip = {
    "/tmp/*",
    "$TMPDIR/*",
    "$TMP/*",
    "$TEMP/*",
    "*/shm/*",
    "/private/var/*",
    ".vault.vim"
  },

  -----------------------------------------------------------
  -- Search
  -----------------------------------------------------------
  grepprg = "rg --hidden --vimgrep --smart-case --",
  grepformat = "%f:%l:%c:%m",
  inccommand = "split", -- When nonempty, shows the effects of :substitute, :smagic, and :snomagic as you type
  incsearch = false,

  magic = true,

  virtualedit = "block",
  viewoptions = "folds,cursor,curdir,slash,unix",

  sessionoptions = { "curdir", "help", "tabpages", "winsize" },

  wildignorecase = true,
  wildignore = ".git,.hg,.svn,*.pyc,*.o,*.out,*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store,**/node_modules/**,**/bower_modules/**",

  -- Disable backups
  backup = false,
  writebackup = false,

  shiftround = true,
  infercase = true,
  wrapscan = true,
  complete = ".,w,b,k",

  breakat = [[\ \	;:,!?]],
  startofline = false,
  whichwrap = "h,l,<,>,[,],~",
  switchbuf = "useopen",
  backspace = { "indent", "eol", "start" },
  diffopt = {
    "internal",
    "filler",
    "closeoff",
    "hiddenoff",
    "algorithm:patience"
  },
  jumpoptions = "stack",
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
  equalalways = false,
  display = "msgsep",
  showbreak = "↳  ",
  listchars = "tab:»·,nbsp:+,trail:·,extends:→,precedes:←",

  formatoptions = "1jcroql",


  autoindent = true, -- Copy indent from current line when starting a new line
}

local window_config = {
  -----------------------------------------------------------
  -- Neovim UI
  -----------------------------------------------------------
  -- number = true, -- Show line number
  numberwidth = 2,
  relativenumber = false,
  linebreak = true, -- Wrap on word boundary
  breakindentopt = "shift:2,min:20",
  colorcolumn = "120",
  signcolumn = "yes:1", -- When and how to draw the signcolumn.

}



for name, value in pairs(global_config) do
  vim.opt[name] = value
end

for name, value in pairs(window_config) do
  vim.wo[name] = value
end

vim.g.vimsyn_embed = "lPr"


-- Disable Distribution Plugins

local disabled_built_ins = {
  -- 'netrw',
  -- 'netrwPlugin',
  -- 'netrwSettings',
  -- 'netrwFileHandlers',
  'gzip',
  'zip',
  'zipPlugin',
  'tar',
  'tarPlugin',
  'getscript',
  'getscriptPlugin',
  'vimball',
  'vimballPlugin',
  '2html_plugin',
  'logipat',
  'rrhelper',
  'spellfile_plugin',
  'fzf',
  -- 'matchit',
  --'matchparen',
}
for _, plugin in pairs(disabled_built_ins) do
  vim.g['loaded_' .. plugin] = 1
end

-- Disable providers

local providers = {
  'perl',
  'ruby',
  'python'
}

for _, provider in pairs(providers) do
  vim.g['loaded_' .. provider .. '_provider'] = 0
end

-- Map leader to <space>
-- vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent=true})
vim.g.mapleader      = ' '
vim.g.maplocalleader = ' '


-- vim.cmd [[packadd menu.vim]]
