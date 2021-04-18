-- Find executable locally
local function setPrettier(exe)
  local fmt_prettier
  if vim.fn.findfile(exe, "node_modules/.bin/") == "node_modules/.bin/prettier" then
    fmt_prettier = "node_modules/.bin/prettier"
  else
    vim.fn.executable(exe)
    fmt_prettier = exe
  end

  return fmt_prettier
end

local prettier = function()
  return {
    exe = setPrettier("prettier"),
    args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0), "--single-quote"},
    stdin = true
  }
end

-- Formatter setup
require("formatter").setup(
  {
    logging = true,
    filetype = {
      javascript = {
        prettier
      },
      javascriptreact = {
        prettier
      },
      typescript = {
        prettier
      },
      typescriptreact = {
        prettier
      },
      json = {
        prettier
      },
      lua = {
        function()
          return {
            exe = "luafmt",
            args = {"--indent-count", 2, "--stdin"},
            stdin = true
          }
        end
      }
    }
  }
)
