local save_and_go = { [[<Esc><Cmd>silent! update | redraw<CR>]], desc = "Save and go to Normal mode" }

return {
  n = {
    ["vK"] = { [[<C-\><C-N>:help <C-R><C-W><CR>]], desc = "Save File Shortcut" },
  },
  i = {
    ["<C-S>"] = save_and_go,
  },
  x = {
    ["<C-S>"] = save_and_go,
  },
}
