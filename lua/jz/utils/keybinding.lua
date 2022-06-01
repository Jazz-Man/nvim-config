local rhs_options = {}

---@return table
function rhs_options:new()
    local instance = {
        cmd = '',
        options = {noremap = true, silent = false, expr = false, nowait = false, buffer = nil},
        mode = 'n',
        keymap = nil
    }
    setmetatable(instance, self)
    self.__index = self
    return instance
end

function rhs_options:map_cmd( cmd_string )
    self.cmd = cmd_string
    return self
end

---@param mode string|function
---@return table
function rhs_options:mode( mode )
    self.mode = mode
    return self
end

---@param key string
---@return table
function rhs_options:map_key( key )
    self.keymap = key
    return self
end

---@param buffer any
---@return table
function rhs_options:with_buffer( buffer )
    self.options.buffer = buffer
    return self

end

---@param cmd_string string
---@return table
function rhs_options:map_cr( cmd_string )
    self.cmd = (':%s<CR>'):format(cmd_string)
    return self
end

---@param cmd_string string
---@return table
function rhs_options:map_args( cmd_string )
    self.cmd = (':%s<Space>'):format(cmd_string)
    return self
end

---@param cmd_string string
---@return table
function rhs_options:map_cu( cmd_string )
    self.cmd = (':<C-u>%s<CR>'):format(cmd_string)
    return self
end

---@return table
function rhs_options:with_silent()
    self.options.silent = true
    return self
end

---@return table
function rhs_options:with_recursive()
    self.options.noremap = false
    return self
end

---@return table
function rhs_options:with_expr()
    self.options.expr = true
    return self
end

---@return table
function rhs_options:with_nowait()
    self.options.nowait = true
    return self
end

local pbind = {}

function pbind.map_cr( cmd_string )
    local ro = rhs_options:new()
    return ro:map_cr(cmd_string)
end

---@param cmd_string string|function
---@return table
function pbind.map_cmd( cmd_string )
    local ro = rhs_options:new()
    return ro:map_cmd(cmd_string)
end

function pbind.map_cu( cmd_string )
    local ro = rhs_options:new()
    return ro:map_cu(cmd_string)
end

function pbind.map_args( cmd_string )
    local ro = rhs_options:new()
    return ro:map_args(cmd_string)
end

---@param mode string|function
---@return table
function pbind.mode( mode )
    local ro = rhs_options:new()
    return ro:mode(mode)
end

---@param key string
---@return table
function pbind.key( key )
    local ro = rhs_options:new()
    return ro:map_key(key)

end

function pbind.nvim_load_mapping( mapping )
    for key, value in pairs(mapping) do
        local mode, keymap = key:match('([^|]*)|?(.*)')
        if type(value) == 'table' then
            local rhs = value.cmd
            local options = value.options
            vim.keymap.set(mode, keymap, rhs, options)
        end
    end
end

return pbind
