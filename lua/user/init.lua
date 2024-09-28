_G.urequire = function(modname)
  local ok, mod = pcall(require, "lua.user." .. modname)

  if not ok then
    vim.notify(mod, vim.log.levels.ERROR)
  else
    return mod
  end
end

_G.rutils = function(modname)
  local ok, mod = pcall(require, "user.lua.jz.utils." .. modname)

  if not ok then
    vim.notify(mod, vim.log.levels.ERROR)
  else
    return mod
  end
end

---Pretty print. Alias for `vim.inspect()`.
_G.pp = function(a, opt) print(vim.inspect(a, opt)) end

return {
  -- Set colorscheme to use
  colorscheme = "onenord",
  lsp = {
    servers = {
      "awk_ls",
      "html",
      "vimls",
      "dotls",
      "lua_ls",
      "lemminx",
      "cssls",
      "cssmodules_ls",
    },
  },
}
