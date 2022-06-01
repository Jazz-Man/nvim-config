local present, cmp = pcall(require, 'cmp')

if not present then return end

local vim = vim

vim.opt.completeopt = {'menu', 'menuone', 'noselect'} -- Autocomplete options
vim.opt.shortmess:append 'c'

local utils = require 'jz.utils'
local icons = require('jz.config.icons')

local luasnip = require('luasnip')

local function cmp_autopairs()

    local ok, autopairs = pcall(require, 'nvim-autopairs')

    if not ok then return end

    autopairs.setup {
        -- fast_wrap = {},
        check_ts = true,
        ts_config = {lua = {'string'}, javascript = {'string', 'template_string'}},
        map_c_h = true,
        map_c_w = true,
        disable_filetype = {
            'TelescopePrompt',
            'vim',
            'guihua',
            'guihua_rust',
            'clap_input'
        }
    }

    cmp.event:on(
      'confirm_done', require('nvim-autopairs.completion.cmp').on_confirm_done()
    )

end

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and
             vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col)
               :match('%s') == nil
end

local sources = {

    {name = 'nvim_lsp'},
    {name = 'omni'},
    {name = 'luasnip'},
    {name = 'nvim_lsp_signature_help'},
    {name = 'treesitter'},
    {name = 'buffer'},
    {name = 'path'}
}

if vim.o.ft == 'lua' then table.insert(sources, {name = 'nvim_lua'}) end

cmp.setup {
    snippet = {
        expand = function( args )
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end
    },

    mapping = cmp.mapping.preset.insert(
      {
          ['<C-e>'] = cmp.mapping {i = cmp.mapping.abort(), c = cmp.mapping
            .close()},

          -- Confirm
          --- disable default confirm action
          ['<C-y>'] = cmp.config.disable,
          --- select confirm by Enter
          ['<CR>'] = cmp.mapping(
            cmp.mapping.confirm {behavior = cmp.ConfirmBehavior.Insert, select = true},
            {'i', 'c'}
          ),
          ['<c-q>'] = cmp.mapping.confirm {
              behavior = cmp.ConfirmBehavior.Replace,
              select = true
          },

          ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),

          --- Compilation by tab
          ['<tab>'] = cmp.mapping(
            function( fallback )

                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip.expandable() then
                    luasnip.expand()
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                elseif has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end

            end, {'i', 's'}
          ),

          ['<S-Tab>'] = cmp.mapping(
            function( fallback )
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end

            end, {'i', 's'}
          )

      }
    ),
    formatting = {
        format = function( _, vim_item )
            vim_item.kind = string.format(
                              '%s %s', icons.lspkind[vim_item.kind],
                              vim_item.kind
                            )

            return vim_item
        end
    },
    sources = cmp.config.sources(sources),

    sorting = {
        comparators = {
            function( entry1, entry2 )
                local types = require 'cmp.types'
                local kind1 = entry1:get_kind()
                local kind2 = entry2:get_kind()
                if kind1 ~= kind2 then
                    if kind1 == types.lsp.CompletionItemKind.Text then
                        return false
                    end
                    if kind2 == types.lsp.CompletionItemKind.Text then
                        return true
                    end
                end
                local score1 = entry1.completion_item.score
                local score2 = entry2.completion_item.score
                if score1 and score2 then
                    local diff = score1 - score2
                    if diff < 0 then
                        return false
                    elseif diff > 0 then
                        return true
                    end
                end
            end,

            -- The built-in comparators:
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order
        }
    },
    experimental = {native_menu = false, ghost_text = true}
}

cmp_autopairs()
