return function( use )
    local conf = require 'jz.modules.editor.config'

    use {'numToStr/Comment.nvim', config = conf.comment}

    use {'mrjones2014/smart-splits.nvim', config = conf.splits}

    use {
        'mg979/vim-visual-multi',
        keys = {
            '<Ctrl>',
            '<M>',
            '<C-n>',
            '<C-n>',
            '<M-n>',
            '<S-Down>',
            '<S-Up>',
            '<M-Left>',
            '<M-i>',
            '<M-Right>',
            '<M-D>',
            '<M-Down>',
            '<C-d>',
            '<C-Down>',
            '<S-Right>',
            '<C-LeftMouse>',
            '<M-LeftMouse>',
            '<M-C-RightMouse>',
            '<Leader>'
        },
        cmd = {'VMDebug', 'VMClear', 'VMLive'},
        config = conf.multi
    }

    use {'tpope/vim-surround', event = 'InsertEnter'}

    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = conf.treesitter,
        event = {'BufRead', 'BufNewFile'},
        requires = {
            {'nvim-treesitter/nvim-treesitter-refactor', after = 'nvim-treesitter'},
            {
                'nvim-treesitter/nvim-treesitter-textobjects',
                after = 'nvim-treesitter'
            },
            {
                'JoosepAlviste/nvim-ts-context-commentstring',
                after = 'nvim-treesitter'
            },
            {'windwp/nvim-ts-autotag', after = 'nvim-treesitter'}
        }
    }

    use {
        'ThePrimeagen/refactoring.nvim',
        config = conf.refactoring,
        requires = {'nvim-lua/plenary.nvim'},
        after = 'nvim-treesitter'
    }

    use {
        'booperlv/nvim-gomove',
        event = {'CursorMoved', 'CursorMovedI'},
        config = conf.nvim_gomove
    }

    use {
        'mbbill/undotree',
        opt = true,
        config = conf.vim_mundo,
        cmd = {'UndotreeToggle', 'UndotreeHide', 'UndotreeShow', 'UndotreeFocus'}
    }

    use {
        'lukas-reineke/indent-blankline.nvim',
        event = 'BufRead',
        config = conf.blankline,
    }
end
