local conf = {}

conf.lspconfig = function()

    require('nvim-lsp-installer').setup(
      {
          automatic_installation = true, -- automatically detect which servers to install (based on which servers are set up via lspconfig)
          ensure_installed = {'sumneko_lua'},
          ui = {
              icons = {
                  server_installed = '✓',
                  server_pending = '➜',
                  server_uninstalled = '✗'
              }
          }
      }
    )

    -- local servers = require 'jz.modules.lsp.config.serverconf'
    -- local lsp_manager = require 'jz.modules.lsp.config.manager'

    local lsp_utils = require 'jz.modules.lsp.config.utils'

    lsp_utils.setup_handlers()

    -- for server, config in pairs(servers) do lsp_manager.setup(server, config) end

    -- lsp_manager.setup('awk_ls')
    -- lsp_manager.setup('bashls')
    -- lsp_manager.setup('dockerls')
    -- lsp_manager.setup('html')
    -- lsp_manager.setup('vimls')
    -- conf.php_lsp()

end

conf.lsp_signature = function() require'lsp_signature'.setup({}) end

conf.illuminate = function() vim.g.Illuminate_ftblacklist = {'nerdtree'} end

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
          log = {enable = true, level = 'warn', use_console = 'async'},
          on_attach = lsp_manager.common_on_attach,
          on_init = lsp_manager.common_on_init,
          on_exit = lsp_manager.common_on_exit,
          sources = {
              code_actions.refactoring,
              code_actions.shellcheck,
              code_actions.eslint_d.with({
                prefer_local = 'node_modules/.bin'
              }),

              completion.spell,
              completion.tags,

              diagnostics.trail_space,
              diagnostics.luacheck,
              diagnostics.shellcheck,
              diagnostics.sqlfluff,
              diagnostics.php,
              diagnostics.psalm,
              diagnostics.phpstan,
              diagnostics.phpmd,
              diagnostics.eslint_d.with({
                  prefer_local = 'node_modules/.bin'
                }),

              formatting.lua_format.with(
                {
                    extra_args = {
                        '-c',
                        string.format(
                          '%s/.config/luaformatter/config.yaml', utils.home
                        )
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

    lsp_manager.setup(
      'jsonls', {
          init_options = {provideFormatter = false},
          settings = {
              json = {
                  schemas = require('schemastore').json.schemas(),
                  validate = {enable = true}
              }
          }
      }
    )
end

conf.ts_lsp = function()

    local lsp_manager = require 'jz.modules.lsp.config.manager'
    local ts_utils = require('nvim-lsp-ts-utils')
    local utils = require 'jz.utils'

    lsp_manager.setup(
      'tsserver', {
          init_options = ts_utils.init_options,
          on_attach = function( client, bufnr )
              ts_utils.setup(
                {
                    debug = false,
                    disable_commands = false,
                    enable_import_on_completion = false,

                    -- import all
                    import_all_timeout = 5000, -- ms
                    -- lower numbers = higher priority
                    import_all_priorities = {
                        same_file = 1, -- add to existing import statement
                        local_files = 2, -- git files or files with relative path markers
                        buffer_content = 3, -- loaded buffer content
                        buffers = 4 -- loaded buffer names
                    },
                    import_all_scan_buffers = 100,
                    import_all_select_source = false,
                    -- if false will avoid organizing imports
                    always_organize_imports = true,

                    -- filter diagnostics
                    filter_out_diagnostics_by_severity = {},
                    filter_out_diagnostics_by_code = {},

                    -- inlay hints
                    auto_inlay_hints = true,
                    inlay_hints_highlight = 'Comment',
                    inlay_hints_priority = 200, -- priority of the hint extmarks
                    inlay_hints_throttle = 150, -- throttle the inlay hint request
                    inlay_hints_format = { -- format options for individual hint kind
                        Type = {},
                        Parameter = {},
                        Enum = {}
                        -- Example format customization for `Type` kind:
                        -- Type = {
                        --     highlight = "Comment",
                        --     text = function(text)
                        --         return "->" .. text:sub(2)
                        --     end,
                        -- },
                    },

                    -- update imports on file move
                    update_imports_on_move = false,
                    require_confirmation_on_move = false,
                    watch_dir = nil
                }
              )

              -- required to fix code action ranges and filter diagnostics
              ts_utils.setup_client(client)

              local options = {buffer = bufnr}
              utils.nmap('gs', ':TSLspOrganize<CR>', options)
              utils.nmap('gr', ':TSLspRenameFile<CR>', options)
              utils.nmap('gi', ':TSLspImportAll<CR>', options)
          end

      }
    )
end

conf.sql_lsp = function()

    local lsp_manager = require 'jz.modules.lsp.config.manager'

    lsp_manager.setup(
      'sqls', {
          on_attach = function( client, bufnr )
              require('sqls').on_attach(client, bufnr)
          end
      }
    )

end

conf.php_lsp = function()

    local lsp_manager = require 'jz.modules.lsp.config.manager'

    local config = {

        init_options = {clearCache = true, licenceKey = '0054ZN3IW58J59M'},
        settings = {
            intelephense = {
                completion = {
                    insertUseDeclaration = true,
                    fullyQualifyGlobalConstantsAndFunctions = true,
                    triggerParameterHints = true,
                    maxItems = 100
                },
                format = {enable = false, braces = 'psr12'},
                phpdoc = {textFormat = 'snippet', useFullyQualifiedNames = true},
                stubs = {
                    'amqp',
                    'apache',
                    'apcu',
                    'bcmath',
                    'blackfire',
                    'bz2',
                    'calendar',
                    'cassandra',
                    'com_dotnet',
                    'Core',
                    'couchbase',
                    'crypto',
                    'ctype',
                    'cubrid',
                    'curl',
                    'date',
                    'dba',
                    'decimal',
                    'dom',
                    'ds',
                    'enchant',
                    'Ev',
                    'event',
                    'exif',
                    'fann',
                    'FFI',
                    'ffmpeg',
                    'fileinfo',
                    'filter',
                    'fpm',
                    'ftp',
                    'gd',
                    'gearman',
                    'geoip',
                    'geos',
                    'gettext',
                    'gmagick',
                    'gmp',
                    'gnupg',
                    'grpc',
                    'hash',
                    'http',
                    'ibm_db2',
                    'iconv',
                    'igbinary',
                    'imagick',
                    'imap',
                    'inotify',
                    'interbase',
                    'intl',
                    'json',
                    'judy',
                    'ldap',
                    'leveldb',
                    'libevent',
                    'libsodium',
                    'libxml',
                    'lua',
                    'lzf',
                    'mailparse',
                    'mapscript',
                    'mbstring',
                    'mcrypt',
                    'memcache',
                    'memcached',
                    'meminfo',
                    'meta',
                    'ming',
                    'mongo',
                    'mongodb',
                    'mosquitto-php',
                    'mqseries',
                    'msgpack',
                    'mssql',
                    'mysql',
                    'mysql_xdevapi',
                    'mysqli',
                    'ncurses',
                    'newrelic',
                    'oauth',
                    'oci8',
                    'odbc',
                    'openssl',
                    'parallel',
                    'Parle',
                    'pcntl',
                    'pcov',
                    'pcre',
                    'pdflib',
                    'PDO',
                    'pdo_ibm',
                    'pdo_mysql',
                    'pdo_pgsql',
                    'pdo_sqlite',
                    'pgsql',
                    'Phar',
                    'phpdbg',
                    'posix',
                    'pspell',
                    'pthreads',
                    'radius',
                    'rar',
                    'rdkafka',
                    'readline',
                    'recode',
                    'redis',
                    'Reflection',
                    'regex',
                    'rpminfo',
                    'rrd',
                    'SaxonC',
                    'session',
                    'shmop',
                    'SimpleXML',
                    'snmp',
                    'soap',
                    'sockets',
                    'sodium',
                    'solr',
                    'SPL',
                    'SplType',
                    'SQLite',
                    'sqlite3',
                    'sqlsrv',
                    'ssh2',
                    'standard',
                    'stats',
                    'stomp',
                    'suhosin',
                    'superglobals',
                    'svn',
                    'sybase',
                    'sync',
                    'sysvmsg',
                    'sysvsem',
                    'sysvshm',
                    'tidy',
                    'tokenizer',
                    'uopz',
                    'uv',
                    'v8js',
                    'wddx',
                    'win32service',
                    'winbinder',
                    'wincache',
                    'wordpress',
                    'xcache',
                    'xdebug',
                    'xhprof',
                    'xml',
                    'xmlreader',
                    'xmlrpc',
                    'xmlwriter',
                    'xsl',
                    'xxtea',
                    'yaf',
                    'yaml',
                    'yar',
                    'zend',
                    'Zend OPcache',
                    'ZendCache',
                    'ZendDebugger',
                    'ZendUtils',
                    'zip',
                    'zlib',
                    'zmq',
                    'zookeeper'
                }
            }
        }
    }

    lsp_manager.setup('intelephense', config)
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
                format = {enable = false},
                diagnostics = {
                    enable = true,
                    -- Get the language server to recognize the `vim` global
                    globals = {'vim', 'nvim', 'RELOAD'}
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

conf.cmp = function()
    local cmp = require('cmp')

    local icons = require 'jz.config.icons'

    local luasnip = require('luasnip')

    local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and
                 vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(
                   col, col
                 ):match('%s') == nil
    end

    local sources = {

        {name = 'nvim_lsp'},
        {name = 'omni'},
        {name = 'luasnip'},
        {name = 'nvim_lsp_signature_help'},
        {name = 'nvim_lua'},
        {name = 'treesitter'},
        {name = 'buffer'},
        {name = 'path'}
    }

    -- if vim.o.ft == 'lua' then table.insert(sources, {name = 'nvim_lua'}) end

    if vim.tbl_contains({'sql', 'mysql', 'plsql'}, vim.o.ft) then

        table.insert(sources, {name = 'vim-dadbod-completion'})
    end

    cmp.setup {
        snippet = {
            expand = function( args )
                require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            end
        },

        completion = {completeopt = 'menu,menuone,noinsert'},

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
                }, {'i', 'c'}
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
        test_flags = {'-v'},
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
        tags_options = {'json=omitempty'},
        tags_transform = 'snakecase',
        tags_flags = {'-skip-unexported'},
        -- quick type
        quick_type_flags = {'--just-types'}
    }

    go.config.update_tool(
      'quicktype', function( tool ) tool.pkg_mgr = 'yarn' end
    )

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

return conf
