local utils = require "jz.utils"

utils.vmap("<leader>re", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]])
utils.vmap("<leader>rf", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]])
utils.vmap("<leader>rv", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]])
utils.vmap("<leader>ri", [[ <Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]])

-- Extract block doesn't need visual mode
utils.nmap("<leader>rb", [[ <Cmd>lua require('refactoring').refactor('Extract Block')<CR>]])
utils.nmap("<leader>rbf", [[ <Cmd>lua require('refactoring').refactor('Extract Block To File')<CR>]])

-- Inline variable can also pick up the identifier currently under the cursor without visual mode
utils.nmap("<leader>ri", [[ <Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]])


-- prompt for a refactor to apply when the remap is triggered
utils.vmap("<leader>rr", ":lua require('refactoring').select_refactor()<CR>")
-- You can also use below = true here to to change the position of the printf
-- statement (or set two remaps for either one). This remap must be made in normal mode.
utils.nmap("<leader>rp", ":lua require('refactoring').debug.printf({below = false})<CR>")

-- Print var: this remap should be made in visual mode
utils.vmap("<leader>rv", ":lua require('refactoring').debug.print_var({})<CR>")

-- Cleanup function: this remap should be made in normal mode
utils.nmap("<leader>rc", ":lua require('refactoring').debug.cleanup({})<CR>")
