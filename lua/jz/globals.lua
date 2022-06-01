local ok, plenary_reload = pcall(require, 'plenary.reload')
if not ok then
    reloader = require
else
    reloader = plenary_reload.reload_module
end

P = function( v )
    print(vim.inspect(v))
    return v
end

RELOAD = function( ... ) return reloader(...) end

---@param name string
R = function( name )
    RELOAD(name)
    return require(name)
end

_G.dump = function( ... ) print(vim.inspect(...)) end

_G.profile = function( cmd, times )
    times = times or 100
    local args = {}
    if type(cmd) == 'string' then
        args = {cmd}
        cmd = vim.cmd
    end
    local start = vim.loop.hrtime()
    for _ = 1, times, 1 do
        local ok = pcall(cmd, unpack(args))
        if not ok then
            error(
              'Command failed: ' .. tostring(ok) .. ' ' ..
                vim.inspect({cmd = cmd, args = args})
            )
        end
    end
    print(((vim.loop.hrtime() - start) / 1000000 / times) .. 'ms')
end

---comment
---@param ... string
---@return nil|table
_G.prequire = function( ... )

    local status, lib = pcall(require, ...)
    if status then return lib end
    return nil
end

-- R('nvim_utils')
