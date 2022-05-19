vim.opt.completeopt = { "menu", "menuone", "noselect" } -- Autocomplete options
vim.opt.shortmess:append "c"

local cmp = prequire("cmp")
local luasnip = prequire("luasnip")

if luasnip then

  require("luasnip.loaders.from_vscode").lazy_load()
  require("luasnip.loaders.from_snipmate").lazy_load()
  require("luasnip.loaders.from_lua").lazy_load()


  luasnip.config.set_config({
    history = false,
    -- Update more often, :h events for more info.
    updateevents = "TextChanged,TextChangedI",
  })

end

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end


if cmp then

  cmp.setup {
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
      end
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-e>"] = cmp.mapping {
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      },

      -- Confirm
      --- disable default confirm action
      ["<C-y>"] = cmp.config.disable,
      --- select confirm by Enter
      ["<CR>"] = cmp.mapping(
        cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
        },
        { "i", "c" }
      ),
      ["<c-q>"] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      },

      ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),

      --- Compilation by tab
      ["<tab>"] = cmp.mapping(function(fallback)

        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip and luasnip.expandable() then
          luasnip.expand()
        elseif luasnip and luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end

      end, { "i", "s" }),

      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip and luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end

      end, { "i", "s" })

    }),
    formatting = {
      format = require("lspkind").cmp_format {
        with_text = true,
        maxwidth = 55,
        menu = {
          buffer = "[buf]",
          nvim_lsp = "[LSP]",
          nvim_lua = "[api]",
          path = "[path]",
          vsnip = "[snip]",
        },
      }
    },
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = 'omni' },
      { name = "luasnip" },
      { name = 'nvim_lsp_signature_help' },
      { name = 'nvim_lua' },
      { name = 'treesitter' },
      { name = "buffer" },
      { name = "path" }
    }),

    sorting = {
      comparators = {
        function(entry1, entry2)
          local types = require "cmp.types"
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
        cmp.config.compare.order,
      },
    },

  }

  -- cmp.setup.cmdline('/', {
  --   mapping = cmp.mapping.preset.cmdline(),
  --   sources = {
  --     { name = 'buffer' }
  --   }
  -- })
  --
  -- cmp.setup.cmdline(':', {
  --   mapping = cmp.mapping.preset.cmdline(),
  --   sources = cmp.config.sources({
  --     { name = 'path' }
  --   }, {
  --     { name = 'cmdline' }
  --   })
  -- })


end
