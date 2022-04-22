local global = require "utils/global"
local A = require "utils/general"

local global_config = {
    -----------------------------------------------------------
    -- General
    -----------------------------------------------------------  
    mouse = "a", -- Enable mouse support
    clipboard = "unnamedplus", -- Copy/paste to system clipboard
    swapfile = false, -- Don't use swapfile
    completeopt = "menu,menuone,noselect,noinsert", -- Autocomplete options
    shada = "!,'300,<50,@100,s10,h",
    textwidth = 100, -- Maximum width of text that is being inserted.

    errorbells = true,
    visualbell = true,

    -----------------------------------------------------------
    -- Encoding and File formatt
    -----------------------------------------------------------
    encoding = "utf-8", -- String-encoding used internally and for RPC communication.
    fileformats = "unix,mac,dos",

    -----------------------------------------------------------
    -- Memory, CPU
    -----------------------------------------------------------
    hidden = true, -- Enable background buffers
    history = 2000, -- Remember N lines in history
    lazyredraw = true, -- Faster scrolling
    synmaxcol = 2500, -- Max column for syntax highlight
    updatetime = 100, -- ms to wait for trigger an event
    timeout = true,
    ttimeout = true,
    timeoutlen = 10,
    ttimeoutlen = 10,
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
    laststatus = 2, -- Set global statusline
    wrap = false,
    showmode = false, -- If in Insert, Replace or Visual mode put a message on the last line.
    pumblend = 10, -- Enables pseudo-transparency for the popup-menu.
    showtabline = 2,

    -----------------------------------------------------------
    -- Fold config
    -----------------------------------------------------------

    foldlevelstart = 99,

    -----------------------------------------------------------
    -- Dirs
    -----------------------------------------------------------
    directory = global.cache_dir .. "swag/", -- List of directory names for the swap file, separated with commas.
    undodir = global.cache_dir .. "undo/",
    undofile = true,
    backupdir = global.cache_dir .. "backup/",
    viewdir = global.cache_dir .. "view/",
    backupskip = "/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*,.vault.vim",
    spellfile = global.cache_dir .. "spell/en.uft-8.add",

    -----------------------------------------------------------
    -- Search
    -----------------------------------------------------------
    grepprg = "rg --hidden --vimgrep --smart-case --",
    grepformat = "%f:%l:%c:%m",
    inccommand = "split", -- When nonempty, shows the effects of :substitute, :smagic, and :snomagic as you type
    incsearch = true,

    magic = true,

    virtualedit = "block",
    viewoptions = "folds,cursor,curdir,slash,unix",

    sessionoptions = "curdir,help,tabpages,winsize",

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
    backspace = "indent,eol,start",
    diffopt = "filler,iwhite,internal,algorithm:patience",
    jumpoptions = "stack",
    shortmess = "aoOTIcF",
    scrolloff = 2,
    sidescrolloff = 5,
    list = true,
    winwidth = 30,
    winminwidth = 10,
    pumheight = 15,
    helpheight = 12,
    previewheight = 12,
    showcmd = false,
    cmdheight = 2,
    cmdwinheight = 5,
    equalalways = false,
    display = "lastline",
    showbreak = "↳  ",
    listchars = "tab:»·,nbsp:+,trail:·,extends:→,precedes:←",

    formatoptions = "1jcroql",

    autoindent = true -- Copy indent from current line when starting a new line
}

local window_config = {
    -----------------------------------------------------------
    -- Neovim UI
    -----------------------------------------------------------
    number = true, -- Show line number
    linebreak = true, -- Wrap on word boundary
    breakindentopt = "shift:2,min:20",
    colorcolumn = "120",
    signcolumn = "yes", -- When and how to draw the signcolumn.
    conceallevel = 2, -- Determine how text with the "conceal" syntax attribute :syn-conceal is shown
    concealcursor = "niv", -- Sets the modes in which text in the cursor line can also be concealed.
    winblend = 10, -- Enables pseudo-transparency for a floating window.

    -----------------------------------------------------------
    -- Fold config
    -----------------------------------------------------------
    foldenable = true,
    foldmethod = "indent"

}

if global.is_mac then
    vim.g.clipboard = {
        name = "macOS-clipboard",
        copy = {["+"] = "pbcopy", ["*"] = "pbcopy"},
        paste = {["+"] = "pbpaste", ["*"] = "pbpaste"},
        cache_enabled = 0
    }
end

for name, value in pairs(global_config) do vim.opt[name] = value end

for name, value in pairs(window_config) do vim.wo[name] = value end

vim.g.vimsyn_embed = "lPr"

vim.g.mapleader = " "
A.Key_mapper("n", " ", "")
A.Key_mapper("x", " ", "")

-- Disable Distribution Plugins

vim.g.loaded_gzip = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1
-- vim.g.loaded_netrwSettings = 1
-- vim.g.loaded_netrwFileHandlers = 1

