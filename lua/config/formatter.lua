
-- Find executable locally
-- local function setPrettier(exe)
--   local fmt_prettier
--   if vim.fn.findfile(exe, "node_modules/.bin/") == "node_modules/.bin/prettier" then
--     fmt_prettier = "node_modules/.bin/prettier"
--   else
--     vim.fn.executable(exe)
--     fmt_prettier = exe
--   end
--   return fmt_prettier
-- end


-- Formatter setup
require("formatter").setup({
  logging = false,
  filetype = {
    lua = {
      luafmt = function()
        return {
          exe = "luafmt",
          args = {"--indent-count", 2, "--stdin"},
          stdin = true
        }
      end
    }
  }
})
