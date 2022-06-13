---@class MapConfig
---@field public silent boolean|nil
---@field public buffer number|boolean|nil
---@field public replace_keycodes boolean|nil
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
local home = os.getenv('HOME')

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
function M.dir_path(path, what)

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
function M.has_key(tab, idx)
    for index, _ in pairs(tab) do if index == idx then return true end end
    return false
end

---@param mode string|table
---@param lhs string
---@param rhs string|function
---@param opts MapConfig|nil
---@param defaults MapConfig|nil

function M.map(mode, lhs, rhs, opts, defaults)
    opts = vim.tbl_deep_extend(
        'force', { silent = true }, defaults or {}, opts or {}
    )

    vim.keymap.set(mode, lhs, rhs, opts)
end

---@param lhs string
---@param rhs string|function
---@param opts MapConfig|nil
function M.nmap(lhs, rhs, opts) M.map('n', lhs, rhs, opts) end

---@param lhs string
---@param rhs string|function
---@param opts MapConfig|nil
function M.vmap(lhs, rhs, opts) M.map('v', lhs, rhs, opts) end

---@param lhs string
---@param rhs string|function
---@param opts MapConfig|nil
function M.xmap(lhs, rhs, opts) M.map('x', lhs, rhs, opts) end

---@param lhs string
---@param rhs string|function
---@param opts MapConfig|nil
function M.imap(lhs, rhs, opts) M.map('i', lhs, rhs, opts) end

---@param lhs string
---@param rhs string|function
---@param opts MapConfig|nil
function M.omap(lhs, rhs, opts) M.map('o', lhs, rhs, opts) end

---@param lhs string
---@param rhs string|function
---@param opts MapConfig|nil
function M.smap(lhs, rhs, opts) M.map('s', lhs, rhs, opts) end

---@param lhs string
---@param rhs string|function
---@param opts MapConfig|nil
function M.cmap(lhs, rhs, opts) M.map('c', lhs, rhs, opts) end

---@param definitions table
function M.autocommand(definitions)
    for group_name, definition in pairs(definitions) do
        local group = vim.api.nvim_create_augroup(group_name, {})

        for _, def in ipairs(definition) do

            local opts = vim.tbl_deep_extend(
                'keep', { group = group }, def.options or {}
            )
            vim.api.nvim_create_autocmd(def.event, opts)
        end

    end
end

---Clear autogroup command
---@param name string
function M.clear_augroup(name)

    local exists, _ = pcall(vim.api.nvim_get_autocmds, { group = name })

    if not exists then return end

    vim.api.nvim_clear_autocmds { group = name }

end

---Keep your cursor position during some actions
---@param arguments string
function M.preserve(arguments)
    local cmd = fmt('keepjumps keeppatterns execute %q', arguments)
    -- local original_cursor = vim.fn.winsaveview()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    vim.api.nvim_command(cmd)
    local lastline = vim.fn.line('$')
    -- vim.fn.winrestview(original_cursor)
    if line > lastline then line = lastline end
    vim.api.nvim_win_set_cursor(0, { line, col })
end

---enter a mode.
---@param name string the name of the mode.
---@param instruction function|string|table a Lua function, keymap dictionary, Vimscript command.
---@param supress_exit boolean|nil
function M.mode_enter(name, instruction, supress_exit)
    local ok, libmodal = pcall(require, 'libmodal')
    if not ok then return end

    libmodal.mode.enter(name, instruction, supress_exit)
end

---enter a prompt.
---@param name string the name of the prompt
---@param instruction function|table<string, function|string> what to do with user input
---@param user_completions table<string>|nil a list of possible inputs, provided by the user
function M.prompt_enter(name, instruction, user_completions)

    local ok, libmodal = pcall(require, 'libmodal')
    if not ok then return end

    libmodal.prompt.enter(name, instruction, user_completions)
end

function M.log(msg, hl, name)
    name = name or 'Neovim'
    hl = hl or 'Todo'
    vim.api.nvim_echo({ { name .. ': ', hl }, { msg } }, true, {})
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

    local rhs = string.format(
        '<cmd>lua R(\'jz.telescope\')[\'%s\'](TelescopeMapArgs[\'%s\'])<CR>',
        f, map_key
    )

    local map_options = { noremap = true, silent = true, buffer = buffer }

    M.map(mode, key, rhs, map_options)
end

M.load_variables()

return M
