---@class RhsOptions
---@field public noremap boolean|nil
---@field public remap boolean|nil
---@field public silent boolean|nil
---@field public expr boolean
---@field public buffer number|boolean
---@field public desc string|nil
---@class RhsClass
---@field public c function
---@field public k function
---@field public leader function
---@field public buffer function
---@field public silent function
---@field public expr function
---@field public desc function
---@field private mode string|table
---@field options RhsOptions
---@class GroupOptions
---@field prefix string|nil
---@field mode string|table|nil
---@field debug boolean
---@field options RhsOptions
local keymap_options = {
    silent = true,
    expr = nil,
    noremap = false,
    remap = nil,
    buffer = nil,
    desc = nil
}

local mode_list = {
    map = '',
    map_ic = '!',
    nmap = 'n',
    vmap = 'v',
    smap = 's',
    xmap = 'x',
    omap = 'o',
    imap = 'i',
    lmap = 'l',
    cmap = 'c',
    tmap = 't'
}

local rhs = {}

local M = {

    group_mapper_active = false,
    group_mapper_options = { prefix = nil, debug = false, buffer = nil, desc = nil }

}

local cmd = {}

local fmt = string.format

---@class CmdOptions
---@field before string|nil
---@field after string|nil
---@param cmd_str string
---@param options CmdOptions|nil
---@return string
function cmd:cmd(cmd_str, options)

    options = vim.tbl_deep_extend(
        'force', { before = '', after = '' }, options or {}
    )

    return fmt('%s<cmd>%s<cr>%s', options.before, cmd_str, options.after)

end

---@param module string
---@param options string
---@return string|nil
function cmd:lua(module, options)
    return cmd:cmd(fmt('lua require"%s".%s', module, options))
end

---@param cmd_str string
---@return string
function cmd:plug(cmd_str) return fmt('<Plug>%s', cmd_str) end

---@param cmd_str string
---@return string
function cmd:cu(cmd_str) return cmd:cmd(cmd_str, { before = '<C-u>' }) end

---@param module string
---@param options string
---@return string
function cmd:treesitter(module, options)
    return cmd:lua(fmt('nvim-treesitter.%s', module), options)
end

---@param module string
---@param options string
---@return string
function cmd:treesitter_textobjects(module, options)

    return cmd:treesitter(fmt('textobjects.%s', module), options)
end

---@param module string
---@param options string
---@return string
function cmd:treesitter_refactor(module, options)

    return cmd:treesitter(fmt('refactor.%s', module), options)
end

---@param options string
---@return string
function cmd:comment(options) return cmd:lua('Comment.api', options) end

---@param toggle string
---@return string
function cmd:comment_call(toggle)

    return cmd:comment(fmt('call("toggle_%s_op")', toggle))
end

function cmd:comment_toggle(toggle)

    local toggle_cmd = fmt('toggle_%s_op(vim.fn.visualmode())', toggle)

    return fmt('<esc>%s', cmd:comment(toggle_cmd))
end

local mapper_options = function(option, default)

    if M.group_mapper_active then

        local cnf = M.group_mapper_options

        if option == 'prefix' and cnf.prefix then

            default = type(default) == 'table' and default or { default }

            return vim.tbl_map(function(k) return cnf.prefix .. k end, default)

        end

        if option == 'desc' and cnf.desc then
            return fmt([[%s: %s]], cnf.desc, default)
        end

        if cnf[option] then return cnf[option] end

        return default
    end
    return default
end

---@param mode string|table
---@param map_option RhsOptions
---@return RhsClass
function rhs:new(mode, map_option)
    local instance = { mode = mode, keymap = nil, options = keymap_options }

    instance.options = vim.tbl_deep_extend(
        'force', instance.options, map_option or {}
    )

    if M.group_mapper_active then

        local cnf = M.group_mapper_options

        if cnf.buffer then instance.options.buffer = cnf.buffer end

    end

    setmetatable(instance, self)
    self.__index = self
    return instance
end

---@param command string|function
function rhs:c(command)

    if not self.keymap then return end

    local lhss = self.keymap
    if type(lhss) ~= 'table' then lhss = { lhss } end

    for _, lhs in ipairs(lhss) do

        vim.keymap.set(self.mode, lhs, command, self.options)
    end

end

---@param key string|table
---@return RhsClass
function rhs:k(key)

    -- if group_mapper.debug then dump(key) end
    self.keymap = mapper_options('prefix', key)

    return self
end

---@param key string
---@return RhsClass
function rhs:leader(key)

    self.keymap = fmt([[<leader>%s]], key)

    return self
end

---@param buffer number|boolean
---@return RhsClass
function rhs:buffer(buffer)
    self.options.buffer = mapper_options('buffer', buffer)
    return self

end

---@return RhsClass
function rhs:remap()
    self.options.remap = mapper_options('remap', true)
    return self
end

---@return RhsClass
function rhs:expr()
    self.options.expr = mapper_options('expr', true)
    return self
end

---@param desc string
---@return RhsClass
function rhs:desc(desc)
    self.options.desc = mapper_options('desc', desc)
    return self
end

local map = {}

local noremap_options = { noremap = true }

---@param mode string|table
---@param map_option RhsOptions|nil
---@return RhsClass
function map:mode(mode, map_option) return rhs:new(mode, map_option) end

---@param map_option RhsOptions|nil
---@return RhsClass
function map:map(map_option) return map:mode(mode_list.map, map_option) end

---@return RhsClass
function map:map_ic() return map:mode(mode_list.map_ic) end

---@return RhsClass
function map:noremap_ic() return map:mode(mode_list.map_ic, noremap_options) end

---@return RhsClass
function map:nmap() return map:mode(mode_list.nmap) end

---@return RhsClass
function map:nnoremap() return map:mode(mode_list.nmap, noremap_options) end

---@return RhsClass
function map:vmap() return map:mode(mode_list.vmap) end

---@return RhsClass
function map:vnoremap() return map:mode(mode_list.vmap, noremap_options) end

---@return RhsClass
function map:smap() return map:mode(mode_list.smap) end

---@return RhsClass
function map:snoremap() return map:mode(mode_list.smap, noremap_options) end

---@return RhsClass
function map:xmap() return map:mode(mode_list.xmap) end

---@return RhsClass
function map:xnoremap() return map:mode(mode_list.xmap, noremap_options) end

---@return RhsClass
function map:omap() return map:mode(mode_list.omap) end

---@return RhsClass
function map:onoremap() return map:mode(mode_list.omap, noremap_options) end

---@return RhsClass
function map:imap() return map:mode(mode_list.imap) end

---@return RhsClass
function map:inoremap() return map:mode(mode_list.imap, noremap_options) end

---@return RhsClass
function map:lmap() return map:mode(mode_list.lmap) end

---@return RhsClass
function map:lnoremap() return map:mode(mode_list.lmap, noremap_options) end

---@return RhsClass
function map:cmap() return map:mode(mode_list.cmap) end

---@return RhsClass
function map:cnoremap() return map:mode(mode_list.cmap, noremap_options) end

---@return RhsClass
function map:tmap() return map:mode(mode_list.tmap) end

---@return RhsClass
function map:tnoremap() return map:mode(mode_list.tmap, noremap_options) end

---@param options GroupOptions
---@param fn function
function map:group(options, fn)

    M.group_mapper_active = true

    local old_options = M.group_mapper_options

    M.group_mapper_options = vim.tbl_deep_extend(
        'force', old_options, options or {}
    )

    fn()
    M.group_mapper_active = false
    M.group_mapper_options = old_options

end

return { map = map, cmd = cmd }
