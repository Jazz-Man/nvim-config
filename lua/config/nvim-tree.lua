local vim = vim
local U = require "utils.general"

vim.api.nvim_set_var("lua_tree_side", "left")
vim.api.nvim_set_var("lua_tree_width", 50)
vim.api.nvim_set_var("lua_tree_ignore", {".git", "node_modules", ".cache", ".js.map", ".css.map", ".DS_Store"})
vim.api.nvim_set_var("lua_tree_auto_open", 1)
vim.api.nvim_set_var("lua_tree_auto_close", 1)
vim.api.nvim_set_var("lua_tree_follow", 1)
vim.api.nvim_set_var("lua_tree_indent_markers", 1)
vim.api.nvim_set_var("lua_tree_hide_dotfiles", 0)
vim.api.nvim_set_var("lua_tree_git_hl", 1)
vim.api.nvim_set_var("lua_tree_root_folder_modifier", ":~")
vim.api.nvim_set_var("lua_tree_tab_open", 1)

U.Key_mapper("n", "<F3>", "<cmd>NvimTreeToggle<CR>", true)
U.Key_mapper("n", "<leader>r", "<cmd>NvimTreeRefresh<CR>", true)
U.Key_mapper("n", "<leader>n", "<cmd>NvimTreeFindFile<CR>", true)
