_G.dump = function(...) print(vim.inspect(...)) end

_G.profile = function(cmd, times)
  times = times or 100
  local args = {}
  if type(cmd) == "string" then
    args = { cmd }
    cmd = vim.cmd
  end
  local start = vim.loop.hrtime()
  for _ = 1, times, 1 do
    local ok = pcall(cmd, unpack(args))
    if not ok then
      error("Command failed: " .. tostring(ok) .. " " ..
        vim.inspect({ cmd = cmd, args = args }))
    end
  end
  print(((vim.loop.hrtime() - start) / 1000000 / times) .. "ms")
end

_G.prequire = function(...)

  local status, lib = pcall(require, ...)
  if status then return lib end
  return nil
end

prequire('nvim_utils')

require('packer_init')

require('ui')