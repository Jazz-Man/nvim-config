---@class MapConfig
---@field public silent boolean|nil
---@field public buffer number|boolean|nil
---@field public replace_keycodes boolean|nil


local lazy = require 'lazy'

local M = {}

local home = os.getenv("HOME")
local path_sep = M.is_windows and "\\" or "/"


M.require_on_index = lazy.require_on_index
M.require_on_module_call = lazy.require_on_module_call
M.require_on_exported_call = lazy.require_on_exported_call


function M.load_variables()
  M.is_mac = jit.os == "OSX"
  M.is_linux = jit.os == "Linux"
  M.is_windows = jit.os == "Windows"
  M.vim_path = home .. path_sep .. ".config" .. path_sep .. "nvim"
  M.cache_dir = home .. path_sep .. ".cache" .. path_sep .. "vim" ..
      path_sep
  M.modules_dir = M.vim_path .. path_sep .. "modules"
  M.snippet_dir = M.vim_path .. path_sep .. "snippets"
  M.template_dir = M.vim_path .. path_sep .. "template"
  M.path_sep = path_sep
  M.home = home
end

--- Check if a directory exists in this path
function M.isdir(path)
  -- "/" works on both Unix and Windows
  return M.exists(path .. "/")
end

-- check index in table
---@param tab table
---@param idx string
---@return boolean
function M.has_key(tab, idx)
  for index, _ in pairs(tab) do
    if index == idx then
      return true
    end
  end
  return false
end

---@param mode string|table
---@param lhs string
---@param rhs string|function
---@param opts MapConfig|nil
---@param defaults MapConfig|nil

function M.map(mode, lhs, rhs, opts, defaults)
  opts = vim.tbl_deep_extend("force", { silent = true }, defaults or {},
    opts or {})

  return vim.keymap.set(mode, lhs, rhs, opts)
end

---@param lhs string
---@param rhs string|function
---@param opts MapConfig|nil
function M.nmap(lhs, rhs, opts)
  M.map("n", lhs, rhs, opts)
end

---@param lhs string
---@param rhs string|function
---@param opts MapConfig|nil
function M.vmap(lhs, rhs, opts)
  M.map("v", lhs, rhs, opts)
end

---@param lhs string
---@param rhs string|function
---@param opts MapConfig|nil
function M.xmap(lhs, rhs, opts)
  M.map("x", lhs, rhs, opts)
end

---@param lhs string
---@param rhs string|function
---@param opts MapConfig|nil
function M.imap(lhs, rhs, opts)
  M.map("i", lhs, rhs, opts)
end

---@param lhs string
---@param rhs string|function
---@param opts MapConfig|nil
function M.omap(lhs, rhs, opts)
  M.map("o", lhs, rhs, opts)
end

---@param lhs string
---@param rhs string|function
---@param opts MapConfig|nil
function M.smap(lhs, rhs, opts)
  M.map("s", lhs, rhs, opts)
end

---@param definitions table
function M.autocommand(definitions)
  for group_name, definition in pairs(definitions) do
    local group = vim.api.nvim_create_augroup(group_name, {})

    for _, def in ipairs(definition) do

      local opts = vim.tbl_deep_extend("keep", { group = group },
        def.options or {})
      vim.api.nvim_create_autocmd(def.event, opts)
    end

  end
end

function M.log(msg, hl, name)
  name = name or "Neovim"
  hl = hl or "Todo"
  vim.api.nvim_echo({ { name .. ": ", hl }, { msg } }, true, {})
end

---@param msg any
---@param name string
function M.warn(msg, name)
  vim.notify(msg, vim.log.levels.WARN, { title = name })
end

---@param msg any
---@param name string
function M.error(msg, name) 
  vim.notify(msg, vim.log.levels.ERROR, { title = name }) 
end

function M.info(msg, name) 
  vim.notify(msg, vim.log.levels.INFO, { title = name }) 
end

---@param ... string|function
---@return table
function M.map_cmd(...)
  return {
    ("<Cmd>%s<CR>"):format(table.concat(vim.tbl_flatten { ... }, " ")),
    noremap = true
  }
end

---@param option any
---@param silent boolean
function M.toggle(option, silent)
  local info = vim.api.nvim_get_option_info(option)
  local scopes = { buf = "bo", win = "wo", global = "o" }
  local scope = scopes[info.scope]
  local options = vim[scope]
  options[option] = not options[option]
  if silent ~= true then
    if options[option] then
      M.info("enabled vim." .. scope .. "." .. option, "Toggle")
    else
      M.warn("disabled vim." .. scope .. "." .. option, "Toggle")
    end
  end
end

function M.map_set(...)
  return {
    ("<Cmd>silent set %s<CR>"):format(
      table.concat(vim.tbl_flatten { ... }, " ")),
    noremap = true
  }
end

function M.toggle_settings(...)
  local parts = {}
  for _, setting in ipairs(vim.tbl_flatten { ... }) do
    table.insert(parts, ("%s! %s?"):format(setting, setting))
  end
  return parts
end

function M.map_toggle_settings(...)
  local parts = {}
  for _, setting in ipairs(vim.tbl_flatten { ... }) do
    table.insert(parts, ("%s! %s?"):format(setting, setting))
  end
  return M.map_set(parts)
end

TelescopeMapArgs = TelescopeMapArgs or {}


---comment
---@param mode string|table
---@param key string
---@param f string|function
---@param options any
---@param buffer any
M.map_tele = function(mode, key, f, options, buffer)

  local map_key = vim.api.nvim_replace_termcodes(key .. f, true, true, true)

  TelescopeMapArgs[map_key] = options or {}


  local rhs = string.format("<cmd>lua R('jz.telescope')['%s'](TelescopeMapArgs['%s'])<CR>", f, map_key)


  local map_options = {
    noremap = true,
    silent = true,
    buffer = buffer,
  }

  M.map(mode, key, rhs, map_options)
end


M.load_variables()

return M
