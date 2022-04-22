require 'nvim_utils'

local autocmd = {
    bufs = {
        {
            "BufWritePost",
            [[$VIM_PATH/*.lua nested source $MYVIMRC | redraw]]
        }, -- Reload Vim script automatically if setlocal autoread
        {
            "BufWritePost,FileWritePost", "*.vim",
            [[nested if &l:autoread > 0 | source <afile> | echo 'source ' . bufname('%') | endif]]
        }, {"BufWritePre", "/tmp/*", "setlocal noundofile"},
        {"BufWritePre", "COMMIT_EDITMSG", "setlocal noundofile"},
        {"BufWritePre", "MERGE_MSG", "setlocal noundofile"},
        {"BufWritePre", "*.tmp", "setlocal noundofile"},
        {"BufWritePre", "*.bak", "setlocal noundofile"}
        --     -- {"BufWritePre", "*.tsx", "lua vim.api.nvim_command('Format')"}
    },
    -- wins = {
    --     -- Highlight current line only on focused window
    --     {
    --         "WinEnter,BufEnter,InsertLeave", "*",
    --         [[if ! &cursorline && &filetype !~# '^\(denite\|clap_\)' && ! &pvw | setlocal cursorline | endif]]
    --     }, {
    --         "WinLeave,BufLeave,InsertEnter", "*",
    --         [[if &cursorline && &filetype !~# '^\(denite\|clap_\)' && ! &pvw | setlocal nocursorline | endif]]
    --     }, -- Equalize window dimensions when resizing vim window
    --     {"VimResized", "*", [[tabdo wincmd =]]},
    --     -- Force write shada on leaving nvim
    --     {
    --         "VimLeave", "*",
    --         [[if has('nvim') | wshada! | else | wviminfo! | endif]]
    --     },
    --     -- Check if file changed when its window is focus, more eager than 'autoread'
    --     {"FocusGained", "* checktime"}
    -- },
    yank = {
        {
            "TextYankPost",
            [[* silent! lua vim.highlight.on_yank({higroup="IncSearch", timeout=400})]]
        }
    },
    cmd = {
        {"CmdLineEnter", "set nosmartcase"}, {"CmdLineLeave", "set smartcase"}
    },
    -- Autocommand that reloads neovim whenever you save the packer_init.lua file
    packer_user_config = {
        {"BufWritePost", "packer_init.lua", "source <afile> | PackerSync"}
    },
    vimrc_incsearch_highlight = {
        {"CmdlineEnter /,\\?  :set hlsearch"},
        {"CmdlineLeave /,\\? :set nohlsearch"}
    }

}

nvim_create_augroups(autocmd)

-- a.Create_augroup(autocmd)
