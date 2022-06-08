local M = {}

function M.cssmodules_lsp() return { init_options = { camelCase = 'dashes' } } end

function M.css_lsp()

  local css_setting = {
    validate = true,
    lint = {
      compatibleVendorPrefixes = 'ignore',
      vendorPrefix = 'warning',
      duplicateProperties = 'ignore',
      emptyRules = 'ignore',
      importStatement = 'ignore'
    }
  }

  return {

    filetypes = { 'css', 'scss', 'sass' },
    settings = { css = css_setting, scss = css_setting, sass = css_setting }
  }
end

function M.json_lsp()

  return {
    init_options = { provideFormatter = false },
    settings = {
      json = {
        schemas = require('schemastore').json.schemas(),
        validate = { enable = true }
      }
    }
  }

end

function M.yaml_lsp()

  return require('yaml-companion').setup(
    {
      builtin_matchers = { kubernetes = { enabled = true } },
      lspconfig = {
        flags = { debounce_text_changes = 150 },
        settings = {
          redhat = { telemetry = { enabled = false } },
          yaml = {
            format = { enable = true },
            hover = true,
            schemaDownload = { enable = true },
            schemaStore = {
              enable = true,
              url = 'https://www.schemastore.org/api/json/catalog.json'
            },
            trace = { server = 'debug' },
            validate = true
          }
        },
        single_file_support = true
      }
    }
  )

end

function M.ts_lsp()

  local ts_utils = require('nvim-lsp-ts-utils')
  local utils = require 'jz.utils'

  local init_options = vim.tbl_deep_extend(
    'force', ts_utils.init_options, {
    npmLocation = '/usr/local/bin/npm',
    preferences = {
      jsxAttributeCompletionStyle = 'auto',
      disableSuggestions = false,
      quotePreference = 'auto',
      includeCompletionsForModuleExports = true,
      includeCompletionsForImportStatements = true,
      includeCompletionsWithSnippetText = true,
      includeCompletionsWithInsertText = true,
      includeAutomaticOptionalChainCompletions = true,
      includeCompletionsWithClassMemberSnippets = true,
      allowIncompleteCompletions = true,
      importModuleSpecifierEnding = 'auto',
      allowTextChangesInNewFiles = true,
      lazyConfiguredProjectsFromExternalProject = true,
      providePrefixAndSuffixTextForRename = true,
      provideRefactorNotApplicableReason = true,
      allowRenameOfImportPath = true,
      includePackageJsonAutoImports = true,
      displayPartsForJSDoc = true,
      generateReturnInDocTemplate = true
    }
  }
  )

  return {
    init_options = init_options,
    settings = {},
    on_attach = function(client, bufnr)
      ts_utils.setup {
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

      -- required to fix code action ranges and filter diagnostics
      ts_utils.setup_client(client)

      local options = { buffer = bufnr }
      utils.nmap('gs', ':TSLspOrganize<CR>', options)
      utils.nmap('gr', ':TSLspRenameFile<CR>', options)
      utils.nmap('gi', ':TSLspImportAll<CR>', options)
    end

  }
end

function M.php_lsp()

  return {

    init_options = { clearCache = true, licenceKey = '0054ZN3IW58J59M' },
    settings = {
      intelephense = {
        compatibility = {
          correctForBaseClassStaticUnionTypes = true,
          correctForArrayAccessArrayAndTraversableArrayUnionTypes = true
        },
        files = {
          exclude = {

            '**/.git/**',
            '**/.svn/**',
            '**/.hg/**',
            '**/CVS/**',
            '**/.DS_Store/**',
            '**/node_modules/**',
            '**/bower_components/**',
            '**/vendor/**/{Tests,tests}/**',
            '**/.history/**',
            '**/vendor/**/vendor/**'
          }
        },
        telemetry = { enabled = false },
        completion = {
          insertUseDeclaration = true,
          fullyQualifyGlobalConstantsAndFunctions = true,
          triggerParameterHints = true,
          maxItems = 100
        },
        format = { enable = false },
        phpdoc = { textFormat = 'snippet', useFullyQualifiedNames = true },
        environment = { shortOpenTag = false },
        diagnostics = { enable = true },
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
end

return M
