---@class AuOptions
---@field buffer number
---@field desc string
---@field pattern string|table
---@field once boolean
---@field nested boolean
---@class AuClass
---@field private options AuOptions
---@field public even function
---@field public command function
---@field public callback function
---@field public once function
---@field public nested function
---@field public pattern function
---@field public buffer function
---@field public desc function
---@field private new function
local au = {}

local fmt = string.format
local autocmds = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local M = {
  active = false,
  options = {
    buffer = nil,
    desc = nil,
    pattern = nil,
    once = nil,
    nested = nil,
    group = nil
  }
}

---@param option string
---@param default any
---@return any
local mapper = function(option, default)

  if M.active then

    local cnf = M.options

    if option == 'desc' and cnf.desc then
      return fmt([[%s: %s]], cnf.desc, default)
    end

    if cnf[option] then return cnf[option] end

    return default

  end

  return default
end

---@param au_group string
---@return boolean
local function au_group_exist(au_group)

  local exists, _ = pcall(vim.api.nvim_get_autocmds, { group = au_group })
  return exists
end

---@param au_group string
---@return integer
local function get_au_group(au_group)

  local group_options = { clear = true }

  if au_group_exist(au_group) then group_options.clear = false end
  return augroup(au_group, group_options)

end

-- @return AuClass
function au:new()

  local state = {
    event = nil,
    au_group = mapper('group', nil),
    options = {
      group = nil,
      pattern = nil,
      command = nil,
      callback = nil,
      buffer = mapper('buffer', nil),
      desc = nil,
      once = mapper('once', nil),
      nested = mapper('nested', nil)
    }
  }

  setmetatable(state, self)
  self.__index = self
  return state

end

---@param event string|table<string>
---@return AuClass
function au:event(event)
  self.event = event
  return self

end

---@param command string
function au:command(command)
  self.options.command = command

  if not self.event then return end
  if self.au_group then self.options.group = get_au_group(self.au_group) end
  autocmds(self.event, self.options)
end

---@param callback function|string
---@return AuClass
function au:callback(callback)

  self.options.callback = callback
  if not self.event then return end
  if self.au_group then self.options.group = get_au_group(self.au_group) end
  autocmds(self.event, self.options)

end

---@return AuClass
function au:once()

  self.options.once = mapper('once', true)
  return self

end

---@return AuClass
function au:nested()
  self.options.nested = mapper('nested', true)
  return self

end

---@param pattern string|table
---@return AuClass
function au:pattern(pattern)
  self.options.pattern = mapper('pattern', pattern)
  return self
end

---@param buffer integer
---@return AuClass
function au:buffer(buffer)
  self.options.buffer = mapper('buffer', buffer)
  return self

end

---@param desc string
---@return AuClass
function au:desc(desc)

  self.options.desc = mapper('desc', desc)
  return self
end

function au:use()
  if not self.event then return end

  if self.au_group then self.options.group = get_au_group(self.au_group) end

  vim.api.nvim_create_autocmd(self.event, self.options)

end

---@param group string|integer
---@return AuClass
function au:group(group)

  self.au_group = mapper('group', group)
  return self
end

local cmd = {}

---@return AuClass
function cmd:au() return au:new() end

---@class AuGroupOptions
---@field buffer number|nil
---@field desc string|nil
---@field pattern string|table|nil
---@field once boolean|nil
---@field nested boolean|nil
---@field group string
---@param cnf AuGroupOptions
---@param fn function
function cmd:au_group(cnf, fn)

  M.active = true

  local old_options = M.options

  M.options = vim.tbl_deep_extend('force', old_options, cnf or {})

  fn()

  M.active = false
  M.options = old_options

end

---@param au_group string
function cmd:clean(au_group)

  if au_group_exist(au_group) then

    vim.api.nvim_clear_autocmds { group = au_group }
  end
end

return cmd
