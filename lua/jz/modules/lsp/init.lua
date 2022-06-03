-- local lsp = {}

-- local conf = require 'jz.modules.lsp.config'

-- lsp['neovim/nvim-lspconfig'] = {
--     -- opt = true,
--     event = { 'BufReadPre', 'BufNewFile' },
--     config = conf.lspconfig,
--     -- requires = {
--     --     'williamboman/nvim-lsp-installer',
--     --     'jose-elias-alvarez/null-ls.nvim',
--     --     'folke/lsp-colors.nvim',
--     --     'ray-x/lsp_signature.nvim',
--     --     'RRethy/vim-illuminate',
--     --     'folke/lua-dev.nvim'
--     -- }
-- }

-- -- lsp['williamboman/nvim-lsp-installer'] = {
-- --     -- opt = true,
-- --     module = 'nvim-lsp-installer',
-- --     -- config = conf.lsp_installer,
-- -- }

-- -- lsp['folke/lua-dev.nvim'] = {
-- --     -- after = { 'null-ls.nvim' },

-- --     -- after = 'nvim-lspconfig'
-- --     -- ft = { "lua" },
-- --     -- config = conf.lua_lsp
-- -- }

-- -- lsp['crispgm/nvim-go'] = {
-- -- config = conf.nvim_go,
-- -- ft = { "go" },

-- -- after = 'nvim-lspconfig'
-- -- }

-- -- lsp['nanotee/sqls.nvim'] = {
-- -- config = conf.sql_lsp,
-- -- ft = { 'sql', 'mysql', 'plsql' },
-- -- after = { "null-ls.nvim" }
-- -- }

-- -- lsp['jose-elias-alvarez/nvim-lsp-ts-utils'] = {
-- --     ft = {
-- --         'javascript',
-- --         'javascriptreact',
-- --         'javascript.jsx',
-- --         'typescript',
-- --         'typescriptreact',
-- --         'typescript.tsx'
-- --     },
-- --     config = conf.ts_lsp,
-- --     after = {'null-ls.nvim'}
-- -- }

-- -- lsp['kristijanhusak/vim-dadbod-completion'] = {
-- -- ft = { 'sql', 'mysql', 'plsql' },
-- -- setup = function()
-- -- vim.cmd(
-- -- [[autocmd FileType sql setlocal omnifunc=vim_dadbod_completion#omni]]
-- -- )
-- -- end
-- -- }

-- lsp['L3MON4D3/LuaSnip'] = {
--     config = conf.luasnip,
--     event = 'InsertEnter',
--     requires = {{'rafamadriz/friendly-snippets', event = 'InsertEnter'}}
-- }

-- lsp['hrsh7th/nvim-cmp'] = {
--     config = conf.cmp,
--     after = {'LuaSnip'},
--     -- The completion plugin
--     requires = {
--         {'hrsh7th/cmp-buffer', after = 'nvim-cmp'},
--         {'hrsh7th/cmp-path', after = 'nvim-cmp'},
--         {'saadparwaiz1/cmp_luasnip', after = {'nvim-cmp', 'LuaSnip'}},
--         {'hrsh7th/cmp-nvim-lsp', after = 'nvim-cmp'},
--         {'hrsh7th/cmp-nvim-lua', after = 'nvim-cmp'},
--         {'hrsh7th/cmp-nvim-lsp-document-symbol', after = 'nvim-cmp'},
--         {'hrsh7th/cmp-nvim-lsp-signature-help', after = 'nvim-cmp'},
--         {'hrsh7th/cmp-omni', after = 'nvim-cmp'},
--         {'ray-x/cmp-treesitter', after = 'nvim-cmp'},
--         {'windwp/nvim-autopairs', config = conf.autopairs, after = 'nvim-cmp'}
--     }
-- }

return function(use)
    
    local conf = require 'jz.modules.lsp.config'
    
    use {
        'neovim/nvim-lspconfig',
        event = 'BufRead',
        -- config = [[require 'jz.lsp']],
        requires = {
            {'williamboman/nvim-lsp-installer', after = 'nvim-lspconfig'},
            {'jose-elias-alvarez/null-ls.nvim', after = 'nvim-lspconfig'},
            {'ray-x/lsp_signature.nvim', after = 'nvim-lspconfig'}
        }
    }
end
