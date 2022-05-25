local status_ok, comment = pcall(require, "Comment")

if not status_ok then
  return
end

local util = require 'jz.utils'

comment.setup({
  padding = true, -- Add a space b/w comment and the line
  sticky = true, -- Whether the cursor should stay at its position

  -- We define all mappings manually to support neovim < 0.7
  mappings = {
    basic = false, -- Includes `gcc`, `gbc`, `gc[count]{motion}` and `gb[count]{motion}`
    extra = false, -- Includes `gco`, `gcO`, `gcA`
    extended = false -- Includes `g>`, `g<`, `g>[count]{motion}` and `g<[count]{motion}`
  },
  -- pre_hook = function(ctx)
  --  local U = require "Comment.utils"

  -- local location = nil
  -- if ctx.ctype == U.ctype.block then
  --   location = require("ts_context_commentstring.utils").get_cursor_location()
  -- elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
  --   location = require("ts_context_commentstring.utils").get_visual_start_location()
  -- end
  --
  --   return require("ts_context_commentstring.internal").calculate_commentstring {
  --     key = ctx.ctype == U.ctype.line and "__default" or "__multiline",
  --    location = location,
  --  }
  --  end,

})

