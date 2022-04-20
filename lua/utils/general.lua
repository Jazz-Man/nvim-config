local U = {}
local vim = vim

-- Create augroups
function U.Create_augroup(definitions)
  for group_name, definition in pairs(definitions) do
    vim.api.nvim_command("augroup " .. group_name)
    vim.api.nvim_command("autocmd!")

    for _, def in ipairs(definition) do
      local command = table.concat(vim.tbl_flatten {"autocmd", def}, " ")
      vim.api.nvim_command(command)
    end
    vim.api.nvim_command("augroup END")
  end
end

-- Key mapping
function U.Key_mapper(mode, key, result, silent, expr, script)
  vim.api.nvim_set_keymap(
    mode,
    key,
    result,
    {
      noremap = true,
      silent = silent or false,
      expr = expr or false,
      script = script or false
    }
  )
end

-- Abbr
function U.SetupCommandAbbr(from, to)
  vim.fn.execute(
    "cnoreabbrev <expr> " ..
      from .. " ((getcmdtype() ==# ':' && getcmdline() ==# '" .. from .. "') ? ('" .. to .. "') : ('" .. from .. "'))"
  )
end

function U.dump(...)
    local objects = vim.tbl_map(vim.inspect, {...})
    print(unpack(objects))
end

-- Extract color values from highlight strings
-- TODO: check for nil values
function U.GetColorFromHighlights(string, t)
  local hi = vim.api.nvim_exec("hi " .. string, true)
  local colo = string.match(hi, "gui" .. t .. "=(%#[%a|%d]+)")
  return colo
end

return U
