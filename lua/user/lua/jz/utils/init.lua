---@class AutoCommandOptions
---@field patter string|[]string
---@field callback function
---@field command string
---@class AutoCommand
---@field event string|table
---@field options AutoCommandOptions
local M = {}

local fmt = string.format
-- | String value           | Help page     | Affected modes                           | Vimscript equivalent |
-- | ---------------------- | ------------- | ---------------------------------------- | -------------------- |
-- | `''` (an empty string) | `mapmode-nvo` | Normal, Visual, Select, Operator-pending | `:map`               |
-- | `'n'`                  | `mapmode-n`   | Normal                                   | `:nmap`              |
-- | `'v'`                  | `mapmode-v`   | Visual and Select                        | `:vmap`              |
-- | `'s'`                  | `mapmode-s`   | Select                                   | `:smap`              |
-- | `'x'`                  | `mapmode-x`   | Visual                                   | `:xmap`              |
-- | `'o'`                  | `mapmode-o`   | Operator-pending                         | `:omap`              |
-- | `'!'`                  | `mapmode-ic`  | Insert and Command-line                  | `:map!`              |
-- | `'i'`                  | `mapmode-i`   | Insert                                   | `:imap`              |
-- | `'l'`                  | `mapmode-l`   | Insert, Command-line, Lang-Arg           | `:lmap`              |
-- | `'c'`                  | `mapmode-c`   | Command-line                             | `:cmap`              |
-- | `'t'`                  | `mapmode-t`   | Terminal                                 | `:tmap`              |

-- local lazy = require 'lazy'

-- Find the proper directory separator depending
-- on lua installation or OS.

local function dir_separator() return vim.fn.has 'win32' == 1 and '\\' or '/' end

---comment
---@param path string
---@param what any
---@return string|boolean
function M.dir_path( path, what )

  if what == nil then what = 'state' end

  local _path = vim.fn.expand(path)

  if _path ~= '://' then return end

  local sep = dir_separator()

  local vim_dir = vim.fn.stdpath(what)

  local dir = fmt('%s%s%s', vim_dir, sep, path)

  if vim.fn.isdirectory(dir) ~= 0 then vim.fn.mkdir(dir, 'p', '0755') end

  return dir
end

---@param plugin string
function M.has( plugin )
  return require('lazy.core.config').plugins[plugin] ~= nil
end

---@param fn fun()
function M.on_very_lazy( fn )
  vim.api.nvim_create_autocmd(
    'User', { pattern = 'VeryLazy', callback = function() fn() end }
  )
end

-- returns the root directory based on:
-- * lsp workspace folders
-- * lsp root_dir
-- * root pattern of filename of the current buffer
-- * root pattern of cwd
---@return string
function M.get_root()
  ---@type string?
  local path = vim.api.nvim_buf_get_name(0)
  path = path ~= '' and vim.loop.fs_realpath(path) or nil
  ---@type string[]
  local roots = {}
  if path then
    for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
      local workspace = client.config.workspace_folders
      local paths = workspace and
                      vim.tbl_map(
                        function( ws ) return vim.uri_to_fname(ws.uri) end,
                        workspace
                      ) or client.config.root_dir and { client.config.root_dir } or
                      {}
      for _, p in ipairs(paths) do
        local r = vim.loop.fs_realpath(p)
        if path:find(r, 1, true) then roots[#roots + 1] = r end
      end
    end
  end
  table.sort(roots, function( a, b ) return #a > #b end)
  ---@type string?
  local root = roots[1]
  if not root then
    path = path and vim.fs.dirname(path) or vim.loop.cwd()
    ---@type string?
    root = vim.fs.find(M.root_patterns, { path = path, upward = true })[1]
    root = root and vim.fs.dirname(root) or vim.loop.cwd()
  end
  ---@cast root string
  return root
end

---@param on_attach fun(client,buffer)
function M.on_attach( on_attach )
  vim.api.nvim_create_autocmd(
    'LspAttach', {
      callback = function( args )
        local buffer = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        on_attach(client, buffer)
      end
    }
  )
end

---@param name string
function M.fg( name )
  ---@type {foreground?:number}?
  local hl = vim.api.nvim_get_hl and vim.api.nvim_get_hl(0, { name = name }) or
               vim.api.nvim_get_hl_by_name(name, true)
  local fg = hl and hl.fg or hl.foreground
  return fg and { fg = string.format('#%06x', fg) }
end

---Keep your cursor position during some actions
---@param arguments string
function M.preserve( arguments )
  local cmd = fmt('keepjumps keeppatterns execute %q', arguments)
  -- local original_cursor = vim.fn.winsaveview()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  vim.api.nvim_command(cmd)
  local lastline = vim.fn.line('$')
  -- vim.fn.winrestview(original_cursor)
  if line > lastline then line = lastline end
  vim.api.nvim_win_set_cursor(0, { line, col })
end

function M.log( msg, hl, name )
  name = name or 'Neovim'
  hl = hl or 'Todo'
  vim.api.nvim_echo({ { name .. ': ', hl }, { msg } }, true, {})
end

---@param msg any
---@param name string
function M.warn( msg, name )
  vim.notify(msg, vim.log.levels.WARN, { title = name })
end

---@param msg any
---@param name string
function M.error( msg, name )
  vim.notify(msg, vim.log.levels.ERROR, { title = name })
end

function M.info( msg, name )
  vim.notify(msg, vim.log.levels.INFO, { title = name })
end

-- M.load_variables()

M.is_mac = vim.fn.has('osx')
M.vim_path = vim.fn.stdpath('config')
M.cache_dir = vim.fn.stdpath('cache')
M.state_dir = vim.fn.stdpath('state')
M.modules_dir = M.dir_path('modules', 'config')
M.snippet_dir = M.dir_path('snippets', 'config')
M.home = vim.env.HOME

return M
