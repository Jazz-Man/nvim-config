return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'folke/neoconf.nvim', cmd = 'Neoconf', config = true },
      {
        'folke/neodev.nvim',
        -- ft = { 'lua' },
        config = {
          library = {
            enabled = true,
            runtime = true,
            types = true,
            plugins = true
          },
          setup_jsonls = true,
          lspconfig = true,
          pathStrict = true
        }
      },
      'mason.nvim',
      {
        'b0o/schemastore.nvim',
        version = false -- last release is way too old
      },
      'williamboman/mason-lspconfig.nvim',
      'ms-jpq/coq_nvim'
    },
    ---@class PluginLspOpts
    opts = function()

      return {
        servers = {
          awk_ls = {},
          bashls = {},
          dockerls = {},
          html = {},
          vimls = {},
          dotls = {},
          jsonls = {
            json = {
              schemas = require('schemastore').json.schemas(),
              validate = { enable = true }
            }
          },
          yamlls = { yaml = { schemas = require('schemastore').yaml.schemas() } },
          lua_ls = {
            settings = {
              Lua = {
                format = { enable = false },
                diagnostics = { enable = true }
              }
            }
          },
          cssls = {
            validate = true,
            lint = {
              compatibleVendorPrefixes = 'ignore',
              vendorPrefix = 'warning',
              duplicateProperties = 'ignore',
              emptyRules = 'ignore',
              importStatement = 'ignore'
            }
          },
          cssmodules_ls = { init_options = { camelCase = 'dashes' } }
        },
        setup = {}
      }

    end,
    ---@param opts PluginLspOpts
    config = function( _, opts )

      local lsp_manager = require 'plugins.lsp.manager'
      local lsp_utils = require 'plugins.lsp.utils'

      lsp_utils.setup_handlers()

      local servers = opts.servers

      ---comment
      ---@param server string
      ---@param config table|nil
      local function setup( server, config )

        local lspconfig = require 'lspconfig'

        local coq = require 'coq'

        local server_config = servers[server] or {}

        server_config = lsp_manager.resolve_config(server_config)

        lspconfig[server].setup(coq.lsp_ensure_capabilities(server_config))

      end

      -- get all the servers that are available thourgh mason-lspconfig
      local have_mason, mlsp = pcall(require, 'mason-lspconfig')

      local all_mslp_servers = {}
      if have_mason then
        all_mslp_servers = vim.tbl_keys(
                             require(
                               'mason-lspconfig.mappings.server'
                             ).lspconfig_to_package
                           )
      end

      local ensure_installed = {} ---@type string[]

      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
          if server_opts.mason == false or
            not vim.tbl_contains(all_mslp_servers, server) then
            setup(server)
          else
            ensure_installed[#ensure_installed + 1] = server
          end
        end
      end

      if have_mason then
        mlsp.setup(
          { ensure_installed = ensure_installed, automatic_installation = true }
        )
        mlsp.setup_handlers({ setup })
      end

    end

  },

  -- formatters
  {
    'jose-elias-alvarez/null-ls.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'mason.nvim' },
    opts = function()
      local au = require 'jz.utils.autocmd'
      local null_ls = require 'null-ls'
      local utils = require 'jz.utils'
      local formatting = null_ls.builtins.formatting
      local diagnostics = null_ls.builtins.diagnostics
      local code_actions = null_ls.builtins.code_actions

      return {
        debug = false,
        log = { enable = true, level = 'warn', use_console = 'async' },
        on_attach = function( _, bufnr )
          au:au():desc('Format on save'):group('LspAutoFormat'):event(
            'BufWritePre'
          ):buffer(bufnr):callback(
            function()

              vim.lsp.buf.format {
                bufnr = bufnr,
                filter = function( lsp_client )
                  return lsp_client.name == 'null-ls'
                end
              }
            end
          )
        end,
        sources = {
          code_actions.refactoring,
          code_actions.shellcheck,
          code_actions.eslint_d.with({ prefer_local = 'node_modules/.bin' }),
          code_actions.gitsigns,
          code_actions.gitrebase,

          diagnostics.codespell,
          diagnostics.yamllint,
          diagnostics.trail_space,
          diagnostics.shellcheck,
          diagnostics.sqlfluff,
          diagnostics.php,
          diagnostics.revive,
          diagnostics.psalm.with(
            {

              -- method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
              -- prefer_local = 'vendor/bin',
              condition = function( nl_utils )
                return nl_utils.root_has_file({ 'psalm.xml' })
              end
            }
          ),
          diagnostics.phpstan.with(
            {
              prefer_local = 'vendor/bin',
              condition = function( nl_utils )
                return nl_utils.root_has_file(
                         { 'phpstan.neon', 'phpstan.neon.dist' }
                       )

              end
            }
          ),
          diagnostics.phpmd.with(
            {
              prefer_local = 'vendor/bin',
              condition = function( nl_utils )
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
          formatting.prettier,
          formatting.codespell,
          formatting.goimports
        }
      }

    end
  },
  {
    'williamboman/mason.nvim',
    build = ':MasonUpdate',
    cmd = 'Mason',
    keys = { { '<leader>cm', '<cmd>Mason<cr>', desc = 'Mason' } },
    opts = {
      ensure_installed = {
        'stylua',
        'shfmt'
        -- "flake8",
      }
    },
    ---@param opts MasonSettings | {ensure_installed: string[]}
    config = function( _, opts )
      require('mason').setup(opts)
      local mr = require('mason-registry')
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then p:install() end
        end
      end
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end
  }

}
