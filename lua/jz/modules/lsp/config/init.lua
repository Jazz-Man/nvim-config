local conf = {}

conf.lspconfig = function()

  require('nvim-lsp-installer').setup(
    {
      automatic_installation = true, -- automatically detect which servers to install (based on which servers are set up via lspconfig)
      ensure_installed = { 'sumneko_lua' },
      ui = {
        icons = {
          server_installed = '✓',
          server_pending = '➜',
          server_uninstalled = '✗'
        }
      }
    }
  )

  local lsp_manager = require 'jz.modules.lsp.config.manager'

  local lsp_utils = require 'jz.modules.lsp.config.utils'
  local servers = require('jz.modules.lsp.config.serverconf')

  lsp_utils.setup_handlers()

  lsp_manager.setup('awk_ls')
  lsp_manager.setup('bashls')
  lsp_manager.setup('dockerls')
  lsp_manager.setup('html')
  lsp_manager.setup('vimls')
  lsp_manager.setup(
    'lemminx', {
    settings = {
      xml = {
        trace = { server = 'verbose' },
        format = { enabled = true },
        validation = {
          noGrammar = 'hint',
          schema = true,
          enabled = true,
          resolveExternalEntities = true
        }
      }
    }
  }
  )
  lsp_manager.setup('intelephense', servers.php_lsp())
  lsp_manager.setup('cssmodules_ls', servers.cssmodules_lsp())

  lsp_manager.setup('cssls', servers.css_lsp())
end

conf.lsp_format = function() require('lsp-format').setup {} end

conf.trouble = function()

  local icons = require 'jz.config.icons'

  require('trouble').setup {
    position = 'right', -- position of the list can be: bottom, top, left, right
    height = 10, -- height of the trouble list when position is top or bottom
    width = 50, -- width of the list when position is left or right
    icons = true, -- use devicons for filenames
    mode = 'document_diagnostics', -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
    fold_open = '', -- icon used for open folds
    fold_closed = '', -- icon used for closed folds
    group = true, -- group results by file
    padding = true, -- add an extra new line on top of the list
    action_keys = { -- key mappings for actions in the trouble list
      -- map to {} to remove a mapping, for example:
      -- close = {},
      close = 'q', -- close the list
      cancel = '<esc>', -- cancel the preview and get back to your last window / buffer / cursor
      refresh = 'r', -- manually refresh
      jump = { '<cr>', '<tab>' }, -- jump to the diagnostic or open / close folds
      open_split = { '<c-x>' }, -- open buffer in new split
      open_vsplit = { '<c-v>' }, -- open buffer in new vsplit
      open_tab = { '<c-t>' }, -- open buffer in new tab
      jump_close = { 'o' }, -- jump to the diagnostic and close the list
      toggle_mode = 'm', -- toggle between "workspace" and "document" diagnostics mode
      toggle_preview = 'P', -- toggle auto_preview
      hover = 'K', -- opens a small popup with the full multiline message
      preview = 'p', -- preview the diagnostic location
      close_folds = { 'zM', 'zm' }, -- close all folds
      open_folds = { 'zR', 'zr' }, -- open all folds
      toggle_fold = { 'zA', 'za' }, -- toggle fold of current file
      previous = 'k', -- preview item
      next = 'j' -- next item
    },
    indent_lines = true, -- add an indent guide below the fold icons
    auto_open = false, -- automatically open the list when you have diagnostics
    auto_close = false, -- automatically close the list when you have no diagnostics
    auto_preview = true, -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
    auto_fold = false, -- automatically fold a file trouble list at creation
    auto_jump = { 'lsp_definitions' }, -- for the given modes, automatically jump if there is only a single result
    signs = {
      -- icons / text used for a diagnostic
      error = icons.lsp.error,
      warning = icons.lsp.warn,
      hint = icons.lsp.hint,
      information = icons.lsp.info,
      other = '﫠'
    },
    use_diagnostic_signs = true -- enabling this will use the signs defined in your lsp client
  }
end

conf.lsp_signature = function()

  local icons = require 'jz.config.icons'
  require 'lsp_signature'.setup(
    { hint_enable = true, hint_prefix = icons.lsp.hint, auto_close_after = 2 }
  )
end

conf.illuminate = function() vim.g.Illuminate_ftblacklist = { 'nerdtree' } end

conf.null_ls = function()
  local lsp_manager = require 'jz.modules.lsp.config.manager'
  local null_ls = require 'null-ls'
  local utils = require 'jz.utils'

  local formatting = null_ls.builtins.formatting
  local diagnostics = null_ls.builtins.diagnostics
  local code_actions = null_ls.builtins.code_actions
  local completion = null_ls.builtins.completion

  null_ls.setup(
    {
      debug = true,
      log = { enable = true, level = 'warn', use_console = 'async' },
      on_attach = lsp_manager.common_on_attach,
      on_init = lsp_manager.common_on_init,
      on_exit = lsp_manager.common_on_exit,
      sources = {
        code_actions.refactoring,
        code_actions.shellcheck,
        code_actions.eslint_d.with({ prefer_local = 'node_modules/.bin' }),

        completion.spell,
        completion.tags,

        diagnostics.trail_space,
        diagnostics.luacheck,
        diagnostics.shellcheck,
        diagnostics.sqlfluff,
        diagnostics.php,
        diagnostics.psalm.with(
          {

            -- method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
            -- prefer_local = 'vendor/bin',
            condition = function(nl_utils)
              return nl_utils.root_has_file({ 'psalm.xml' })
            end
          }
        ),
        diagnostics.phpstan.with(
          {
            prefer_local = 'vendor/bin',
            condition = function(nl_utils)
              return nl_utils.root_has_file(
                { 'phpstan.neon', 'phpstan.neon.dist' }
              )

            end
          }
        ),
        diagnostics.phpmd.with(
          {
            prefer_local = 'vendor/bin',
            condition = function(nl_utils)
              return nl_utils.root_has_file({ 'phpmd.ruleset.xml' })
            end
          }
        ),
        -- diagnostics.eslint_d.with({ prefer_local = 'node_modules/.bin' }),

        formatting.lua_format.with(
          {
            extra_args = {
              '-c',
              string.format('%s/.config/luaformatter/config.yaml', utils.home)
            }
          }
        ),

        formatting.shfmt,
        formatting.jq,
        formatting.sqlfluff,
        formatting.phpcsfixer,
        formatting.prettier
      }
    }
  )
end

conf.jsonls_lsp = function()

  local lsp_manager = require 'jz.modules.lsp.config.manager'

  local servers = require('jz.modules.lsp.config.serverconf')
  lsp_manager.setup('jsonls', servers.json_lsp())
end

conf.yaml_lsp = function()
  local lsp_manager = require 'jz.modules.lsp.config.manager'

  local servers = require('jz.modules.lsp.config.serverconf')
  require('telescope').load_extension('yaml_schema')

  lsp_manager.setup('yamlls', servers.yaml_lsp())

end

conf.ts_lsp = function()

  local lsp_manager = require 'jz.modules.lsp.config.manager'

  local servers = require('jz.modules.lsp.config.serverconf')

  lsp_manager.setup('tsserver', servers.ts_lsp())
end

conf.sql_lsp = function()

  local lsp_manager = require 'jz.modules.lsp.config.manager'

  lsp_manager.setup(
    'sqls', {
    on_attach = function(client, bufnr)
      require('sqls').on_attach(client, bufnr)
    end
  }
  )

end

conf.lua_lsp = function()
  local lsp_manager = require 'jz.modules.lsp.config.manager'
  local lua_dev = require 'lua-dev'

  local luadevcfg = {
    library = {
      vimruntime = true, -- runtime path
      types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
      plugins = true
    },
    runtime_path = true
  }

  local luadev = lua_dev.setup(luadevcfg)

  local config = {
    settings = {
      Lua = {
        format = { enable = false },
        diagnostics = {
          enable = true,
          -- Get the language server to recognize the `vim` global
          globals = { 'vim', 'nvim', 'RELOAD' }
        }
      }
    }
  }

  config = vim.tbl_deep_extend('force', luadev, config)

  lsp_manager.setup('sumneko_lua', config)
end

conf.luasnip = function()
  local luasnip = require('luasnip')

  require('luasnip.loaders.from_vscode').lazy_load()
  require('luasnip.loaders.from_snipmate').lazy_load()
  require('luasnip.loaders.from_lua').lazy_load()

  luasnip.config.set_config(
    {
      history = false,
      -- Update more often, :h events for more info.
      updateevents = 'TextChanged,TextChangedI'
    }
  )

end

conf.autopairs = function()
  local autopairs = require('nvim-autopairs')
  local cmp = require('cmp')

  autopairs.setup {
    -- fast_wrap = {},
    check_ts = true,
    ts_config = {
      lua = { 'string' },
      javascript = { 'string', 'template_string' }
    },
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

conf.cmp = function()
  local cmp = require('cmp')

  local icons = require 'jz.config.icons'

  local luasnip = require('luasnip')

  local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and
        vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col)
        :match('%s') == nil
  end

  local sources = {

    { name = 'nvim_lsp' },
    { name = 'nvim_lua' },
    { name = 'omni' },
    { name = 'luasnip' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'treesitter' },
    { name = 'buffer' },
    { name = 'path' }
  }

  if vim.tbl_contains({ 'sql', 'mysql', 'plsql' }, vim.o.ft) then

    table.insert(sources, { name = 'vim-dadbod-completion' })
  end

  cmp.setup {
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      end
    },

    mapping = cmp.mapping.preset.insert(
      {
        ['<C-e>'] = cmp.mapping {
          i = cmp.mapping.abort(),
          c = cmp.mapping.close()
        },

        -- Confirm
        --- disable default confirm action
        ['<C-y>'] = cmp.config.disable,
        --- select confirm by Enter
        ['<CR>'] = cmp.mapping(
          cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select = true
          }, { 'i', 'c' }
        ),
        ['<c-q>'] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Replace,
          select = true
        },

        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),

        --- Compilation by tab
        ['<tab>'] = cmp.mapping(
          function(fallback)

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

          end, { 'i', 's' }
        ),

        ['<S-Tab>'] = cmp.mapping(
          function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end

          end, { 'i', 's' }
        )

      }
    ),
    formatting = {
      format = function(_, vim_item)
        vim_item.kind = string.format(
          '%s %s', icons.lspkind[vim_item.kind], vim_item.kind
        )

        return vim_item
      end
    },
    sources = cmp.config.sources(sources),

    sorting = {
      comparators = {
        function(entry1, entry2)
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
    experimental = { native_menu = false, ghost_text = true }
  }

end

conf.nvim_go = function()
  local lsp_manager = require 'jz.modules.lsp.config.manager'
  local go = require 'go'

  go.setup {
    -- notify: use nvim-notify
    notify = false,
    -- auto commands
    auto_format = true,
    auto_lint = true,
    -- linters: revive, errcheck, staticcheck, golangci-lint
    linter = 'revive',
    -- linter_flags: e.g., {revive = {'-config', '/path/to/config.yml'}}
    linter_flags = {},
    -- lint_prompt_style: qf (quickfix), vt (virtual text)
    lint_prompt_style = 'vt',
    -- formatter: goimports, gofmt, gofumpt
    formatter = 'goimports',
    -- test flags: -count=1 will disable cache
    test_flags = { '-v' },
    test_timeout = '30s',
    test_env = {},
    -- show test result with popup window
    test_popup = true,
    test_popup_auto_leave = false,
    test_popup_width = 80,
    test_popup_height = 10,
    -- test open
    test_open_cmd = 'edit',
    -- struct tags
    tags_name = 'json',
    tags_options = { 'json=omitempty' },
    tags_transform = 'snakecase',
    tags_flags = { '-skip-unexported' },
    -- quick type
    quick_type_flags = { '--just-types' }
  }

  go.config.update_tool('quicktype', function(tool) tool.pkg_mgr = 'yarn' end)

  lsp_manager.setup(
    'gopls', {
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
          unreachable = false,
          fieldalignment = true,
          nilness = true,
          shadow = true,
          unusedwrite = true,
          useany = true
        },
        codelenses = {
          generate = true,
          gc_details = true,
          test = true,
          tidy = true,
          upgrade_dependency = true,
          regenerate_cgo = true
        },
        annotations = {
          bounds = true,
          escape = true,
          inline = true,
          ['nil'] = true
        },
        staticcheck = true,
        usePlaceholders = true,
        completeUnimported = true,
        hoverKind = 'Structured',
        experimentalUseInvalidMetadata = true,
        experimentalPostfixCompletions = true
      }
    }
  }
  )

end

conf.symbols_outline = function()
  local icons = require 'jz.config.icons'

  vim.g.symbols_outline = {

    highlight_hovered_item = true,
    show_guides = true,
    position = 'right',
    border = 'single',
    relative_width = true,
    width = 25,
    auto_close = false,
    auto_preview = true,
    show_numbers = false,
    show_relative_numbers = false,
    show_symbol_details = true,
    preview_bg_highlight = 'Pmenu',
    winblend = 0,
    keymaps = { -- These keymaps can be a string or a table for multiple keys
      close = { '<Esc>', 'q' },
      goto_location = '<Cr>',
      focus_location = 'o',
      hover_symbol = '<C-space>',
      toggle_preview = 'K',
      rename_symbol = 'r',
      code_actions = 'a',
      show_help = '?'
    },
    lsp_blacklist = {},
    symbol_blacklist = {},
    symbols = {
      File = { icon = icons.icons.file, hl = 'TSURI' },
      Module = { icon = '', hl = 'TSNamespace' },
      Namespace = { icon = '', hl = 'TSNamespace' },
      Package = { icon = icons.icons.package, hl = 'TSNamespace' },
      Class = { icon = icons.lspkind.Class, hl = 'TSType' },
      Method = { icon = 'ƒ', hl = 'TSMethod' },
      Property = { icon = '', hl = 'TSMethod' },
      Field = { icon = '', hl = 'TSField' },
      Constructor = { icon = icons.lspkind.Constructor, hl = 'TSConstructor' },
      Enum = { icon = 'ℰ', hl = 'TSType' },
      Interface = { icon = 'ﰮ', hl = 'TSType' },
      Function = { icon = '', hl = 'TSFunction' },
      Variable = { icon = '', hl = 'TSConstant' },
      Constant = { icon = '', hl = 'TSConstant' },
      String = { icon = '𝓐', hl = 'TSString' },
      Number = { icon = '#', hl = 'TSNumber' },
      Boolean = { icon = '⊨', hl = 'TSBoolean' },
      Array = { icon = '', hl = 'TSConstant' },
      Object = { icon = '⦿', hl = 'TSType' },
      Key = { icon = '🔐', hl = 'TSType' },
      Null = { icon = 'NULL', hl = 'TSType' },
      EnumMember = { icon = '', hl = 'TSField' },
      Struct = { icon = '𝓢', hl = 'TSType' },
      Event = { icon = '🗲', hl = 'TSType' },
      Operator = { icon = '+', hl = 'TSOperator' },
      TypeParameter = { icon = '𝙏', hl = 'TSParameter' }
    }

  }

end

return conf
