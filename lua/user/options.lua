local fmt = string.format
local fn = vim.fn   -- access vim functions
local opt = vim.opt -- global for let options

-- opt.rtp:append(astronvim.install.config .. "/lua/user/lua")
-- opt.rtp:append(astronvim.install.config .. "/jz")
-- opt.rtp:append(astronvim.install.config .. "/lua/user/options")

opt.completeopt:append { "noinsert", "menuone", "noselect", "preview" }
opt.shortmess:append "c"

opt.formatoptions = "l"

opt.formatoptions = opt.formatoptions
    - "a" -- Auto formatting is BAD.
    - "t" -- Don't auto format my code. I got linters for that.
    + "c" -- In general, I like it when comments respect textwidth
    + "q" -- Allow formatting comments w/ gq
    - "o" -- O and o, don't continue comments
    + "r" -- But do continue when pressing enter.
    + "n" -- Indent past the formatlistpat, not underneath it.
    + "j" -- Auto-remove comments if possible.
    - "2" -- I'm not in gradeschool anymore


-- print(vim.inspect(opt.rtp))


return {
  opt = {
    rtp = opt.rtp,
    exrc = false,       -- enable exrc
    secure = true,      -- enable secure mode
    shell = "/bin/zsh", -- change default shell
    swapfile = false,
    shada = { "!", "'300", "<50", "@100", "s10", "h" },
    textwidth = 100, -- Maximum width of text that is being inserted.
    fileformats = { "unix", "dos", "mac" },
    fileformat = "unix",

    history = 2000,     -- Remember N lines in history
    lazyredraw = true,  -- Faster scrolling

    synmaxcol = 500,    -- Max column for syntax highlight
    redrawtime = 1500,  -- Time in milliseconds for redrawing the display.

    joinspaces = false, -- When joining lines, don't insert a space between them

    emoji = false,
    title = true, -- Set the title of the window
    titlestring = fmt("%s:%s", fn.getpid(), fn.getcwd()),

    syntax = "on", -- Syntax highlighting

    suffixes = opt.suffixes + {
      ".aux",
      ".log",
      ".dvi",
      ".bbl",
      ".blg",
      ".brf",
      ".cb",
      ".ind",
      ".idx",
      ".ilg",
      ".inx",
      ".out",
      ".toc",
      ".o",
      ".obj",
      ".dll",
      ".class",
      ".pyc",
      ".ipynb",
      ".so",
      ".swp",
      ".zip",
      ".exe",
      ".jar",
      ".gz",
    },

    showmatch = true,      -- Show matching brackets when text indicator is over them
    magic = true,          -- Enable regex magic

    wildignorecase = true, -- Ignore case when completing file names

    wildignore = {
      ".git",
      ".hg",
      ".svn",
      "*.pyc",
      "*.o",
      "*.out",
      "*.jpg",
      "*.jpeg",
      "*.png",
      "*.gif",
      "*.zip",
      "**/tmp/**",
      "*.DS_Store",
      "**/node_modules/**",
      "**/bower_modules/**",
    },                       -- Ignore files in these directories
    shiftround = true,       -- Round indent
    complete = ".,w,b,k",    -- Set autocomplete
    breakat = [[\ \	;:,!?]], -- Break lines at these characters

    whichwrap = opt.whichwrap:append "<>[]hl",
    iskeyword = opt.iskeyword:append "-",

    formatoptions = opt.formatoptions,
    completeopt = opt.completeopt,
    shortmess = opt.shortmess,

    switchbuf = "useopen", -- Switch to an existing buffer
    diffopt = {
      "internal",
      "filler",
      "closeoff",
      "hiddenoff",
      "algorithm:patience",
    },                     -- Diff options
    jumpoptions = "stack", -- Jump options
    scrolloff = 2,         -- Scroll offset
    sidescrolloff = 5,     -- Scroll offset

    winwidth = 30,         -- Window width
    winminwidth = 10,      -- Minimum window width

    helpheight = 12,       -- Help window height
    previewheight = 12,    -- Preview window height
    showcmd = true,        -- Show command in bottom bar

    cmdwinheight = 5,      -- Command window height

    equalalways = true,    -- When true, equalalways

    display = "msgsep",

    showbreak = "↳  ", -- Show a line break

    autoindent = true, -- Auto indent

    wildmode = "full", -- Command-line completion mode
  },

  wo = {
    number = true,          -- Show line numbers
    relativenumber = false, -- Show relative line numbers

    breakindentopt = "shift:2,min:20",
  },

  bo = {
    softtabstop = -1, -- Disable soft tabs
  },
}
