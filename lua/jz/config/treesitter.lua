local status_ok, configs = pcall(require, 'nvim-treesitter.configs')
if not status_ok then return end

vim.wo.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'

configs.setup {
    ensure_installed = 'all',
    highlight = {
        enable = true, -- false will disable the whole extension
        additional_vim_regex_highlighting = false
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            -- mappings for incremental selection (visual mappings)
            init_selection = '<CR>', -- maps in normal mode to init the node/scope selection
            scope_incremental = '<Tab>', -- increment to the upper scope (as defined in locals.scm)
            node_incremental = '<CR>', -- increment to the upper named parent
            node_decremental = '<S-Tab>' -- decrement to the previous node
        }
    },
    indent = {enable = true},
    refactor = {
        highlight_defintions = {enable = true, clear_on_cursor_move = true},
        highlight_current_scope = {
            enable = false -- Breaks virtual text
        },
        smart_rename = {enable = true, keymaps = {smart_rename = '<leader>gr'}},
        navigation = {
            enable = true,
            keymaps = {
                goto_definition = 'gnd', -- mapping togo to definition of symbol under cursor
                list_definitions = 'gnD', -- mapping to list all definitions in current file
                goto_next_usage = '<c-n>',
                goto_previous_usage = '<c-p>'
            }
        }
    },
    textobjects = {
        select = {
            enable = true,
            lookahead = true,
            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ['af'] = '@function.outer',
                ['if'] = '@function.inner',
                ['ac'] = '@class.outer',
                ['ic'] = '@class.inner'
            }
        },
        swap = {
            enable = true,
            swap_next = {['<leader>a'] = '@parameter.inner'},
            swap_previous = {['<leader>A'] = '@parameter.inner'}
        },
        move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {[']m'] = '@function.outer', [']]'] = '@class.outer'},
            goto_next_end = {[']M'] = '@function.outer', [']['] = '@class.outer'},
            goto_previous_start = {
                ['[m'] = '@function.outer',
                ['[['] = '@class.outer'
            },
            goto_previous_end = {['[M'] = '@function.outer', ['[]'] = '@class.outer'}
        },
        lsp_interop = {
            enable = true,
            border = 'single',
            peek_definition_code = {
                ['df'] = '@function.outer',
                ['dF'] = '@class.outer'
            }
        }
    },
    context_commentstring = {enable = true},
    playground = {enable = true},
    autotag = {enable = true},
    autopairs = {enable = true}
}
