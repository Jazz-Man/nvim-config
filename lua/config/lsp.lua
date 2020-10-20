local K = require "utils/general"

local nvim_lsp = require("nvim_lsp")
local lsp_status = require("lsp-status")
local completion = require("completion")
local diagnostic = require("diagnostic")

lsp_status.config {
  kind_labels = vim.g.completion_customize_lsp_label,
  select_symbol = function(cursor_pos, symbol)
    if symbol.valueRange then
      local value_range = {
        ["start"] = {character = 0, line = vim.fn.byte2line(symbol.valueRange[1])},
        ["end"] = {character = 0, line = vim.fn.byte2line(symbol.valueRange[2])}
      }

      return require("lsp-status/util").in_range(cursor_pos, value_range)
    end
  end
}

-- Taken from https://www.reddit.com/r/neovim/comments/gyb077/nvimlsp_peek_defination_javascript_ttserver/
function preview_location(location, context, before_context)
  -- location may be LocationLink or Location (more useful for the former)
  context = context or 10
  before_context = before_context or 5
  local uri = location.targetUri or location.uri
  if uri == nil then
    return
  end
  local bufnr = vim.uri_to_bufnr(uri)
  if not vim.api.nvim_buf_is_loaded(bufnr) then
    vim.fn.bufload(bufnr)
  end
  local range = location.targetRange or location.range
  local contents =
    vim.api.nvim_buf_get_lines(bufnr, range.start.line - before_context, range["end"].line + 1 + context, false)
  local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
  return vim.lsp.util.open_floating_preview(contents, filetype)
end

function preview_location_callback(_, method, result)
  local context = 10
  if result == nil or vim.tbl_isempty(result) then
    print("No location found: " .. method)
    return nil
  end
  if vim.tbl_islist(result) then
    floating_buf, floating_win = preview_location(result[1], context)
  else
    floating_buf, floating_win = preview_location(result, context)
  end
end

function peek_definition()
  if vim.tbl_contains(vim.api.nvim_list_wins(), floating_win) then
    vim.api.nvim_set_current_win(floating_win)
  else
    local params = vim.lsp.util.make_position_params()
    return vim.lsp.buf_request(0, "textDocument/definition", params, preview_location_callback)
  end
end

lsp_status.register_progress()

local function make_on_attach(config, bufnr)
  return function(client)
    if config.before then
      config.before(client)
    end

    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
    lsp_status.on_attach(client, bufnr)
    diagnostic.on_attach(client, bufnr)
    completion.on_attach(client, bufnr)
    K.Key_mapper("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", true)
    K.Key_mapper("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", true)
    K.Key_mapper("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", true)
    K.Key_mapper("i", "gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>", true)
    K.Key_mapper("n", "g0", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", true)
    K.Key_mapper("n", "gW", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>", true)
    K.Key_mapper("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", true)

    K.Key_mapper("n", "<Leader>de", "<cmd>lua vim.lsp.buf.declaration()<CR>", true)
    K.Key_mapper("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", true)
    K.Key_mapper("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", true)
    K.Key_mapper("n", "ga", "<cmd>lua vim.lsp.buf.code_action()<CR>", true)
    K.Key_mapper("n", "gD", "<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>", true)

    K.Key_mapper("n", "]d", ":PrevDiagnostic<CR>", true)
    K.Key_mapper("n", "[d", ":NextDiagnostic<CR>", true)
    K.Key_mapper("n", "[D", "PrevDiagnosticCycle<CR>", true)
    K.Key_mapper("n", "]D", ":NextDiagnosticCycle<CR>", true)
    K.Key_mapper("n", "<Leader>f", "<cmd>Format<CR>", true)
    K.Key_mapper("n", "pd", "<cmd>lua peek_definition()<CR>", true)

    -- if client.resolved_capabilities.document_formatting then
    K.Key_mapper("n", "<leader>lf", "<cmd>lua vim.lsp.buf.formatting()<cr>", true)
    -- end

    if client.resolved_capabilities.document_highlight then
      local group = {
        lsp_aucmds = {
          "CursorHold <buffer> lua vim.lsp.buf.document_highlight()",
          "CursorMoved <buffer> lua vim.lsp.buf.clear_references()"
        }
      }

      K.Create_augroup(group)
    end

    if config.after then
      config.after(client)
    end
  end
end

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
    -- root_dir = nvim_lsp.util.root_pattern("package.json", ".git"),
    settings = {
      css = cssLSSetting,
      scss = cssLSSetting,
      less = cssLSSetting,
      sass = cssLSSetting
    }
  },
  html = {},
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
  tsserver = {},
  sumneko_lua = {
    settings = {
      Lua = {
        runtime = {version = "LuaJIT", path = vim.split(package.path, ";")},
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
          textFormat = "text"
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

local snippet_capabilities = {
  textDocument = {completion = {completionItem = {snippetSupport = true}}}
}

local function deep_extend(policy, ...)
  local result = {}
  local function helper(policy, k, v1, v2)
    if type(v1) ~= "table" or type(v2) ~= "table" then
      if policy == "error" then
        error("Key " .. vim.inspect(k) .. " is already present with value " .. vim.inspect(v1))
      elseif policy == "force" then
        return v2
      else
        return v1
      end
    else
      return deep_extend(policy, v1, v2)
    end
  end

  for _, t in ipairs({...}) do
    for k, v in pairs(t) do
      if result[k] ~= nil then
        result[k] = helper(policy, k, result[k], v)
      else
        result[k] = v
      end
    end
  end

  return result
end

for server, config in pairs(servers) do
  config.on_attach = make_on_attach(config)
  config.capabilities = deep_extend("keep", config.capabilities or {}, lsp_status.capabilities, snippet_capabilities)

  nvim_lsp[server].setup(config)
end
