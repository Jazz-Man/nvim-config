local nvim_lsp = require("lspconfig")

local system_name
if vim.fn.has("mac") == 1 then
  system_name = "macOS"
elseif vim.fn.has("unix") == 1 then
  system_name = "Linux"
elseif vim.fn.has('win32') == 1 then
  system_name = "Windows"
else
  print("Unsupported system for sumneko")
end

-- set the path to the sumneko installation; if you previously installed via the now deprecated :LspInstall, use
local sumneko_root_path = '/Users/vasilsokolik/tools/lua-language-server'
local sumneko_binary = sumneko_root_path.."/bin/macOS/lua-language-server"

local cssLintSettings = {
  compatibleVendorPrefixes = "ignore",
  vendorPrefix = "warning",
  duplicateProperties = "ignore",
  emptyRules = "ignore",
  importStatement = "ignore"
}

local cssLSSetting = {
  validate = true,
  lint = cssLintSettings
}

local servers = {
  bashls = {},
  sqlls = {
cmd = {"sql-language-server", "up", "--method", "stdio"};
},
  dockerls = {},
  cssls = {
    filetypes = {"css", "scss", "less", "sass"},
    root_dir = nvim_lsp.util.root_pattern("package.json", ".git"),
    settings = {
      css = cssLSSetting,
      scss = cssLSSetting,
      less = cssLSSetting,
      sass = cssLSSetting
    }
  },
  jdtls = {},
  html = {},
  diagnosticls = {
    filetypes = {"javascript", "javascriptreact", "typescript", "typescriptreact", "css", "scss"},
    init_options = {
      linters = {
        eslint = {
          command = "eslint",
          rootPatterns = {".git"},
          debounce = 100,
          args = {"--stdin", "--stdin-filename", "%filepath", "--format", "json"},
          sourceName = "eslint",
          parseJson = {
            errorsRoot = "[0].messages",
            line = "line",
            column = "column",
            endLine = "endLine",
            endColumn = "endColumn",
            message = "[eslint] ${message} [${ruleId}]",
            security = "severity"
          },
          securities = {
            [2] = "error",
            [1] = "warning"
          }
        }
      },
      filetypes = {
        javascript = "eslint",
        javascriptreact = "eslint",
        typescript = "eslint",
        typescriptreact = "eslint"
      },
      formatters = {
        prettierEslint = {
          command = "prettier-eslint",
          args = {"--stdin"},
          rootPatterns = {".git"}
        },
        prettier = {
          command = "prettier",
          args = {"--stdin-filepath", "%filename"}
        }
      },
      formatFiletypes = {
        css = "prettier",
        javascript = "prettierEslint",
        javascriptreact = "prettierEslint",
        json = "prettier",
        scss = "prettier",
        typescript = "prettierEslint",
        typescriptreact = "prettierEslint"
      }
    }
  },
  jsonls = {
    init_options = {
      provideFormatter = true
    },
    settings = {
      json = {
        schemas = {
          {
            description = "TypeScript compiler configuration file",
            fileMatch = {"tsconfig.json", "tsconfig.*.json"},
            url = "http://json.schemastore.org/tsconfig"
          },
          {
            description = "Babel configuration",
            fileMatch = {".babelrc.json", ".babelrc", "babel.config.json"},
            url = "http://json.schemastore.org/lerna"
          },
          {
            description = "ESLint config",
            fileMatch = {".eslintrc.json", ".eslintrc"},
            url = "http://json.schemastore.org/eslintrc"
          },
          {
            description = "Prettier config",
            fileMatch = {".prettierrc", ".prettierrc.json", "prettier.config.json"},
            url = "http://json.schemastore.org/prettierrc"
          },
          {
            description = "Vercel Now config",
            fileMatch = {"now.json"},
            url = "http://json.schemastore.org/now"
          },
          {
            description = "Stylelint config",
            fileMatch = {".stylelintrc", ".stylelintrc.json", "stylelint.config.json"},
            url = "http://json.schemastore.org/stylelintrc"
          },
          {
            description = "NPM package.json files",
            fileMatch = {"package.json"},
            url = "https://json.schemastore.org/package"
          },
          {
            description = "PHP Package",
            fileMatch = {"composer.json"},
            url = "https://json.schemastore.org/composer"
          },
          {
            description = "JSHint configuration files",
            fileMatch = {".jshintrc"},
            url = "https://json.schemastore.org/jshintrc"
          }
        }
      }
    }
  },
  vimls = {},
  yamlls = {
    settings = {
      yaml = {
        completion = true,
        hover = true,
        format = {
          enable = true,
          bracketSpacing = true,
          printWidth = 80,
          proseWrap = "preserve",
          singleQuote = true
        },
        schemaStore = {
          enable = true
        }
      }
    }
  },
  tsserver = {},
  intelephense = {
    init_options = {
      clearCache = true,
      licenceKey = "0054ZN3IW58J59M"
    },
    settings = {
      intelephense = {
        completion = {
          insertUseDeclaration = true,
          fullyQualifyGlobalConstantsAndFunctions = true,
          triggerParameterHints = true,
          maxItems = 100
        },
        format = {
          enable = true,
          braces = "psr12"
        },
        phpdoc = {
          textFormat = "snippet",
          useFullyQualifiedNames = true
        },
        stubs = {
          "amqp",
          "apache",
          "apcu",
          "bcmath",
          "blackfire",
          "bz2",
          "calendar",
          "cassandra",
          "com_dotnet",
          "Core",
          "couchbase",
          "crypto",
          "ctype",
          "cubrid",
          "curl",
          "date",
          "dba",
          "decimal",
          "dom",
          "ds",
          "enchant",
          "Ev",
          "event",
          "exif",
          "fann",
          "FFI",
          "ffmpeg",
          "fileinfo",
          "filter",
          "fpm",
          "ftp",
          "gd",
          "gearman",
          "geoip",
          "geos",
          "gettext",
          "gmagick",
          "gmp",
          "gnupg",
          "grpc",
          "hash",
          "http",
          "ibm_db2",
          "iconv",
          "igbinary",
          "imagick",
          "imap",
          "inotify",
          "interbase",
          "intl",
          "json",
          "judy",
          "ldap",
          "leveldb",
          "libevent",
          "libsodium",
          "libxml",
          "lua",
          "lzf",
          "mailparse",
          "mapscript",
          "mbstring",
          "mcrypt",
          "memcache",
          "memcached",
          "meminfo",
          "meta",
          "ming",
          "mongo",
          "mongodb",
          "mosquitto-php",
          "mqseries",
          "msgpack",
          "mssql",
          "mysql",
          "mysql_xdevapi",
          "mysqli",
          "ncurses",
          "newrelic",
          "oauth",
          "oci8",
          "odbc",
          "openssl",
          "parallel",
          "Parle",
          "pcntl",
          "pcov",
          "pcre",
          "pdflib",
          "PDO",
          "pdo_ibm",
          "pdo_mysql",
          "pdo_pgsql",
          "pdo_sqlite",
          "pgsql",
          "Phar",
          "phpdbg",
          "posix",
          "pspell",
          "pthreads",
          "radius",
          "rar",
          "rdkafka",
          "readline",
          "recode",
          "redis",
          "Reflection",
          "regex",
          "rpminfo",
          "rrd",
          "SaxonC",
          "session",
          "shmop",
          "SimpleXML",
          "snmp",
          "soap",
          "sockets",
          "sodium",
          "solr",
          "SPL",
          "SplType",
          "SQLite",
          "sqlite3",
          "sqlsrv",
          "ssh2",
          "standard",
          "stats",
          "stomp",
          "suhosin",
          "superglobals",
          "svn",
          "sybase",
          "sync",
          "sysvmsg",
          "sysvsem",
          "sysvshm",
          "tidy",
          "tokenizer",
          "uopz",
          "uv",
          "v8js",
          "wddx",
          "win32service",
          "winbinder",
          "wincache",
          "wordpress",
          "xcache",
          "xdebug",
          "xhprof",
          "xml",
          "xmlreader",
          "xmlrpc",
          "xmlwriter",
          "xsl",
          "xxtea",
          "yaf",
          "yaml",
          "yar",
          "zend",
          "Zend OPcache",
          "ZendCache",
          "ZendDebugger",
          "ZendUtils",
          "zip",
          "zlib",
          "zmq",
          "zookeeper"
        }
      }
    }
  }
}

return servers
