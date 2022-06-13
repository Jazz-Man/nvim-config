local rhs_options = {}

local fmt = string.format

---@return table
function rhs_options:new()
    local instance = {
        cmd = '',
        options = {
            noremap = true,
            silent = false,
            expr = false,
            nowait = false,
            buffer = nil
        },
        mode = 'n',
        keymap = nil
    }
    setmetatable(instance, self)
    self.__index = self
    return instance
end

---@param cmd string
---@return string
local function cr_cmd(cmd) return fmt('%s<cr>', cmd) end

---@param cmd string
---@return string
local function plug(cmd) return fmt('<Plug>%s', cmd) end

function rhs_options:map_cmd(cmd_string)
    self.cmd = cmd_string
    return self
end

---@param mode string|table
---@return table
function rhs_options:mode(mode)
    self.mode = mode
    return self
end

---@param key string
---@return table
function rhs_options:key(key)
    self.keymap = key
    return self
end

---@param buffer any
---@return table
function rhs_options:buffer(buffer)
    self.options.buffer = buffer
    return self

end

---@param cmd_string string
---@return table
function rhs_options:map_cr(cmd_string)
    self.cmd = cr_cmd(cmd_string)
    return self
end

---@param cmd_string string
---@return table
function rhs_options:map_args(cmd_string)
    self.cmd = fmt(':%s<Space>', cmd_string)
    return self
end

---@param cmd_string string
---@return table
function rhs_options:map_cu(cmd_string)
    self.cmd = fmt(':<C-u>%s<CR>', cmd_string)
    return self
end

---@return table
function rhs_options:silent()
    self.options.silent = true
    return self
end

---@return table
function rhs_options:noremap()
    self.options.noremap = false
    return self
end

---@return table
function rhs_options:expr()
    self.options.expr = true
    return self
end

---@return table
function rhs_options:nowait()
    self.options.nowait = true
    return self
end

local map = {}

function map.map_cr(cmd_string)
    local ro = rhs_options:new()
    return ro:map_cr(cmd_string)
end

---@param cmd_string string|function
---@return table
function map.map_cmd(cmd_string)
    local ro = rhs_options:new()
    return ro:map_cmd(cmd_string)
end

function map.map_cu(cmd_string)
    local ro = rhs_options:new()
    return ro:map_cu(cmd_string)
end

function map.map_args(cmd_string)
    local ro = rhs_options:new()
    return ro:map_args(cmd_string)
end

---@param mode string|function
---@return table
function map.mode(mode)
    local ro = rhs_options:new()
    return ro:mode(mode)
end

---@param key string
---@return table
function map.key(key)
    local ro = rhs_options:new()
    return ro:key(key)

end

function map.nvim_load_mapping(mapping)
    for key, value in pairs(mapping) do
        local mode, keymap = key:match('([^|]*)|?(.*)')
        if type(value) == 'table' then
            local rhs = value.cmd
            local options = value.options
            vim.keymap.set(mode, keymap, rhs, options)
        end
    end
end

return map
