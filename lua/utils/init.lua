local M = {}

M.functions = {}

function M.execute(id)
  local func = M.functions[id]
  if not func then error("Function doest not exist: " .. id) end
  return func()
end


---@param mode string|table
---@param lhs string
---@param rhs string|function
---@param opts table
---@param defaults table

local map = function(mode, lhs, rhs, opts, defaults)
  opts = vim.tbl_deep_extend("force", { silent = true }, defaults or {},
    opts or {})


  return vim.keymap.set(mode, lhs, rhs, opts)
end

---@param mode string|table
---@param lhs string
---@param rhs string|function
---@param opts table
---@param defaults table
function M.map(mode, lhs, rhs, opts, defaults)
  return map(mode, lhs, rhs, opts, defaults)
end


---@param lhs string
---@param rhs string|function
---@param opts table
---@return unknown
function M.nmap(lhs, rhs, opts) return map("n", lhs, rhs, opts) end

function M.vmap(lhs, rhs, opts) return map("v", lhs, rhs, opts) end

function M.xmap(lhs, rhs, opts) return map("x", lhs, rhs, opts) end

function M.imap(lhs, rhs, opts) return map("i", lhs, rhs, opts) end

function M.omap(lhs, rhs, opts) return map("o", lhs, rhs, opts) end

function M.smap(lhs, rhs, opts) return map("s", lhs, rhs, opts) end

---@deprecated
function M.nnoremap(lhs, rhs, opts)
  return map("n", lhs, rhs, opts, { noremap = true })
end

---@deprecated
function M.vnoremap(lhs, rhs, opts)
  return map("v", lhs, rhs, opts, { noremap = true })
end

---@deprecated
function M.xnoremap(lhs, rhs, opts)
  return map("x", lhs, rhs, opts, { noremap = true })
end

---@deprecated
function M.inoremap(lhs, rhs, opts)
  return map("i", lhs, rhs, opts, { noremap = true })
end

---@deprecated
function M.onoremap(lhs, rhs, opts)
  return map("o", lhs, rhs, opts, { noremap = true })
end

---@deprecated
function M.snoremap(lhs, rhs, opts)
  return map("s", lhs, rhs, opts, { noremap = true })
end

function M.autocommand(definitions)
  for group_name, definition in pairs(definitions) do
    local group = vim.api.nvim_create_augroup(group_name, {})

    for _, def in ipairs(definition) do

      local opts = vim.tbl_deep_extend("keep", { group = group }, def.options or {})
      vim.api.nvim_create_autocmd(def.event, opts)
    end

  end
end

function M.log(msg, hl, name)
  name = name or "Neovim"
  hl = hl or "Todo"
  vim.api.nvim_echo({ { name .. ": ", hl }, { msg } }, true, {})
end

function M.warn(msg, name) vim.notify(msg, vim.log.levels.WARN, { title = name }) end

function M.error(msg, name) vim.notify(msg, vim.log.levels.ERROR, { title = name }) end

function M.info(msg, name) vim.notify(msg, vim.log.levels.INFO, { title = name }) end

function M.map_cmd(...)
  return {
    ("<Cmd>%s<CR>"):format(table.concat(vim.tbl_flatten { ... }, " ")),
    noremap = true
  }
end

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

return M
