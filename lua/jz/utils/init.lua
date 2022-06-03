---@class MapConfig
---@field public silent boolean|nil
---@field public buffer number|boolean|nil
---@field public replace_keycodes boolean|nil
local M = {}

-- local lazy = require 'lazy'
local home = os.getenv("HOME")


-- M.require_on_index = lazy.require_on_index
-- M.require_on_module_call = lazy.require_on_module_call
-- M.require_on_exported_call = lazy.require_on_exported_call


function M.load_variables()
    M.is_mac = jit.os == 'OSX'
    M.vim_path = vim.fn.stdpath('config')
    M.cache_dir = vim.fn.stdpath('cache')
    M.state_dir = vim.fn.stdpath('state')
    M.modules_dir = M.dir_path('modules', 'config')
    M.snippet_dir = M.dir_path('snippets', 'config')
    M.home = home
end

-- Find the proper directory separator depending
-- on lua installation or OS.
local function dir_separator() return vim.fn.has 'win32' == 1 and '\\' or '/' end

---comment
---@param path string
---@param what any
---@return string
function M.dir_path( path, what )

    if what == nil then what = 'state' end

    local _path = vim.fn.expand(path)

    if _path ~= '://' then return end

    local sep = dir_separator()

    local vim_dir = vim.fn.stdpath(what)

    local dir = string.format('%s%s%s', vim_dir, sep, path)

    if vim.fn.isdirectory(dir) ~= 0 then vim.fn.mkdir(dir, 'p', '0755') end

    return dir
end

-- check index in table
---@param tab table
---@param idx string
---@return boolean
function M.has_key( tab, idx )
    for index, _ in pairs(tab) do if index == idx then return true end end
    return false
end

---@param mode string|table
---@param lhs string
---@param rhs string|function
---@param opts MapConfig|nil
---@param defaults MapConfig|nil

function M.map( mode, lhs, rhs, opts, defaults )
    opts = vim.tbl_deep_extend(
             'force', {silent = true}, defaults or {}, opts or {}
           )

    return vim.keymap.set(mode, lhs, rhs, opts)
end

---@param lhs string
---@param rhs string|function
---@param opts MapConfig|nil
function M.nmap( lhs, rhs, opts ) M.map('n', lhs, rhs, opts) end

---@param lhs string
---@param rhs string|function
---@param opts MapConfig|nil
function M.vmap( lhs, rhs, opts ) M.map('v', lhs, rhs, opts) end

---@param lhs string
---@param rhs string|function
---@param opts MapConfig|nil
function M.xmap( lhs, rhs, opts ) M.map('x', lhs, rhs, opts) end

---@param lhs string
---@param rhs string|function
---@param opts MapConfig|nil
function M.imap( lhs, rhs, opts ) M.map('i', lhs, rhs, opts) end

---@param lhs string
---@param rhs string|function
---@param opts MapConfig|nil
function M.omap( lhs, rhs, opts ) M.map('o', lhs, rhs, opts) end

---@param lhs string
---@param rhs string|function
---@param opts MapConfig|nil
function M.smap( lhs, rhs, opts ) M.map('s', lhs, rhs, opts) end

---@param definitions table
function M.autocommand( definitions )
    for group_name, definition in pairs(definitions) do
        local group = vim.api.nvim_create_augroup(group_name, {})

        for _, def in ipairs(definition) do

            local opts = vim.tbl_deep_extend(
                           'keep', {group = group}, def.options or {}
                         )
            vim.api.nvim_create_autocmd(def.event, opts)
        end

    end
end

function M.clear_augroup( name )

    local exists, _ = pcall(vim.api.nvim_get_autocmds, {group = name})

    if not exists then return end

    vim.api.nvim_clear_autocmds {group = name}

end

function M.log( msg, hl, name )
    name = name or 'Neovim'
    hl = hl or 'Todo'
    vim.api.nvim_echo({{name .. ': ', hl}, {msg}}, true, {})
end

---@param msg any
---@param name string
function M.warn( msg, name ) vim.notify(msg, vim.log.levels.WARN, {title = name}) end

---@param msg any
---@param name string
function M.error( msg, name )
    vim.notify(msg, vim.log.levels.ERROR, {title = name})
end

function M.info( msg, name ) vim.notify(msg, vim.log.levels.INFO, {title = name}) end

---@param ... string|function
---@return table
function M.map_cmd( ... )
    return {
        ('<Cmd>%s<CR>'):format(table.concat(vim.tbl_flatten {...}, ' ')),
        noremap = true
    }
end

---@param option any
---@param silent boolean
function M.toggle( option, silent )
    local info = vim.api.nvim_get_option_info(option)
    local scopes = {buf = 'bo', win = 'wo', global = 'o'}
    local scope = scopes[info.scope]
    local options = vim[scope]
    options[option] = not options[option]
    if silent ~= true then
        if options[option] then
            M.info('enabled vim.' .. scope .. '.' .. option, 'Toggle')
        else
            M.warn('disabled vim.' .. scope .. '.' .. option, 'Toggle')
        end
    end
end

function M.map_set( ... )
    return {
        ('<Cmd>silent set %s<CR>'):format(
          table.concat(
            vim.tbl_flatten {...}, ' '
          )
        ),
        noremap = true
    }
end

function M.toggle_settings( ... )
    local parts = {}
    for _, setting in ipairs(vim.tbl_flatten {...}) do
        table.insert(parts, ('%s! %s?'):format(setting, setting))
    end
    return parts
end

function M.map_toggle_settings( ... )
    local parts = {}
    for _, setting in ipairs(vim.tbl_flatten {...}) do
        table.insert(parts, ('%s! %s?'):format(setting, setting))
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
M.map_tele = function( mode, key, f, options, buffer )

    local map_key = vim.api.nvim_replace_termcodes(key .. f, true, true, true)

    TelescopeMapArgs[map_key] = options or {}

    local rhs = string.format(
                  '<cmd>lua R(\'jz.telescope\')[\'%s\'](TelescopeMapArgs[\'%s\'])<CR>',
                  f, map_key
                )

    local map_options = {noremap = true, silent = true, buffer = buffer}

    M.map(mode, key, rhs, map_options)
end

M.load_variables()

return M
