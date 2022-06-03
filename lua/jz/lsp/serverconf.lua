local cssLintSettings = {
    compatibleVendorPrefixes = 'ignore',
    vendorPrefix = 'warning',
    duplicateProperties = 'ignore',
    emptyRules = 'ignore',
    importStatement = 'ignore'
}

local cssLSSetting = {validate = true, lint = cssLintSettings}

-- lua setup
local library = {}

local function add( lib )
    for _, p in pairs(vim.fn.expand(lib, false, true)) do
        p = vim.loop.fs_realpath(p)
        if p then library[p] = true end
    end
end

-- add runtime
add('$VIMRUNTIME')

-- add your config
add(vim.fn.stdpath('config'))

library[vim.fn.expand('$VIMRUNTIME/lua')] = true
library[vim.fn.expand('$VIMRUNTIME/lua/vim')] = true
library[vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true

local luadevcfg = {
    library = {
        vimruntime = true, -- runtime path
        types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
        plugins = true
    },
    runtime_path = true
}

local luadev = {}

local ok, l = pcall(require, 'lua-dev')
if ok and l then luadev = l.setup(luadevcfg) end

local servers = {
    cssls = {
        filetypes = {'css', 'scss', 'less', 'sass'},
        settings = {
            css = cssLSSetting,
            scss = cssLSSetting,
            less = cssLSSetting,
            sass = cssLSSetting
        }
    },
    jsonls = {
        init_options = {provideFormatter = true},
        settings = {
            json = {
                schemas = {
                    {
                        description = 'TypeScript compiler configuration file',
                        fileMatch = {'tsconfig.json', 'tsconfig.*.json'},
                        url = 'http://json.schemastore.org/tsconfig'
                    },
                    {
                        description = 'Babel configuration',
                        fileMatch = {
                            '.babelrc.json',
                            '.babelrc',
                            'babel.config.json'
                        },
                        url = 'http://json.schemastore.org/lerna'
                    },
                    {
                        description = 'ESLint config',
                        fileMatch = {'.eslintrc.json', '.eslintrc'},
                        url = 'http://json.schemastore.org/eslintrc'
                    },
                    {
                        description = 'Prettier config',
                        fileMatch = {
                            '.prettierrc',
                            '.prettierrc.json',
                            'prettier.config.json'
                        },
                        url = 'http://json.schemastore.org/prettierrc'
                    },
                    {
                        description = 'Vercel Now config',
                        fileMatch = {'now.json'},
                        url = 'http://json.schemastore.org/now'
                    },
                    {
                        description = 'Stylelint config',
                        fileMatch = {
                            '.stylelintrc',
                            '.stylelintrc.json',
                            'stylelint.config.json'
                        },
                        url = 'http://json.schemastore.org/stylelintrc'
                    },
                    {
                        description = 'NPM package.json files',
                        fileMatch = {'package.json'},
                        url = 'https://json.schemastore.org/package'
                    },
                    {
                        description = 'PHP Package',
                        fileMatch = {'composer.json'},
                        url = 'https://json.schemastore.org/composer'
                    },
                    {
                        description = 'JSHint configuration files',
                        fileMatch = {'.jshintrc'},
                        url = 'https://json.schemastore.org/jshintrc'
                    }
                }
            }
        }
    },
    yamlls = {
        settings = {
            yaml = {
                completion = true,
                hover = true,
                format = {
                    enable = true,
                    bracketSpacing = true,
                    printWidth = 80,
                    proseWrap = 'preserve',
                    singleQuote = true
                },
                schemaStore = {enable = true}
            }
        }
    },
    sumneko_lua = {
        settings = {
            Lua = {
                runtime = {version = 'LuaJIT'},
                diagnostics = {
                    enable = true,
                    -- Get the language server to recognize the `vim` global
                    globals = {'vim', 'nvim', 'RELOAD'}
                },
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = library,
                    maxPreload = 2000,
                    preloadFileSize = 40000
                },
                -- Do not send telemetry data containing a randomized but unique identifier
                telemetry = {enable = false}
            }
        }
    },
    intelephense = {
        init_options = {clearCache = true, licenceKey = '0054ZN3IW58J59M'},
        settings = {
            intelephense = {
                completion = {
                    insertUseDeclaration = true,
                    fullyQualifyGlobalConstantsAndFunctions = true,
                    triggerParameterHints = true,
                    maxItems = 100
                },
                format = {enable = true, braces = 'psr12'},
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
}

servers.sumneko_lua = vim.tbl_deep_extend('force', luadev, servers.sumneko_lua)

return servers
