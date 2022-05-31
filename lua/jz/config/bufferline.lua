local present, bufferline = pcall(require, "bufferline")

if not present then
  return
end

local icons = require("jz.config.icons")

bufferline.setup({
  offsets = {
    { filetype = "NvimTree", text = "", padding = 1 } },
  buffer_close_icon = icons.icons.close,
  modified_icon = icons.icons.circle,
  close_icon = icons.icons.error,
  show_close_icon = false,
  left_trunc_marker = icons.icons.left,
  right_trunc_marker = icons.icons.right,
  max_name_length = 14,
  max_prefix_length = 13,
  tab_size = 20,
  show_tab_indicators = true,
  enforce_regular_tabs = false,
  view = "multiwindow",
  show_buffer_close_icons = true,
  separator_style = "thin",
  always_show_bufferline = true,
  diagnostics = false,
  themable = true,
})
