local nvim_lsp = require("nvim_lsp")

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
  sqlls = {},
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
    settings = {
      json = {
        colorDecorators = {
          enable = true
        },
        format = {
          enable = true
        },
        schemaDownload = {
          enable = true
        },
        schemas = {
          {
            fileMatch = {
              "package.json"
            },
            uri = "https://json.schemastore.org/package"
          },
          {
            fileMatch = {
              "composer.json"
            },
            uri = "https://json.schemastore.org/composer"
          },
          {
            fileMatch = {"tsconfig.json"},
            uri = "https://json.schemastore.org/tsconfig"
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
  tsserver = {
    filetypes = {"javascript", "javascriptreact", "typescript", "typescriptreact"},
    root_patterns = {"package.json", "tsconfig.json", ".git"}
  },
  sumneko_lua = {
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
          path = vim.split(package.path, ";")
        },
        completion = {keywordSnippet = "Disable"},
        diagnostics = {
          enable = true,
          globals = {
            "vim",
            "describe",
            "it",
            "before_each",
            "after_each"
          }
        },
        workspace = {
          library = {
            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
            [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true
          }
        }
      }
    }
  },
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
