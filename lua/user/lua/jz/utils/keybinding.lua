local cmd = {}

local fmt = string.format

---@class CmdOptions
---@field before string|nil
---@field after string|nil
---@param cmd_str string
---@param options CmdOptions|nil
---@return string
function cmd:cmd(cmd_str, options)
  options = vim.tbl_deep_extend("force", { before = "", after = "" }, options or {})

  return fmt("%s<cmd>%s<cr>%s", options.before, cmd_str, options.after)
end

---@param module string
---@param options string
---@return string|nil
function cmd:lua(module, options) return cmd:cmd(fmt('lua require"%s".%s', module, options)) end

---@param cmd_str string
---@return string
function cmd:plug(cmd_str) return fmt("<Plug>%s", cmd_str) end

---@param cmd_str string
---@return string
function cmd:cu(cmd_str) return cmd:cmd(cmd_str, { before = "<C-u>" }) end

return { cmd = cmd }
