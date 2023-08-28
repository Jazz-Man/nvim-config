local au = require "jz.utils.autocmd"

local opt_local = vim.opt_local

au:au_group({ group = "no_cursorline_in_insert_mode" }, function()
  au:au():event({ "InsertLeave", "WinEnter", "BufEnter" }):callback(function() opt_local.cursorline = true end)

  au:au():event({ "InsertEnter", "WinLeave", "BufLeave" }):callback(function() opt_local.cursorline = false end)
end)

au:au()
    :group("disable_undo")
    :event("BufWritePre")
    :pattern({ "/tmp/*", "COMMIT_EDITMSG", "MERGE_MSG", "*.tmp", "*bak" })
    :callback(function() opt_local.undofile = false end)

au:au():group("yank"):pattern("*"):event("TextYankPost"):callback(
  function() vim.highlight.on_yank { timeout = 100 } end
)

au:au():group("auto_resize"):event("VimResized"):pattern("*"):command "tabdo wincmd ="

au:au_group({ group = "terminal_settings" }, function()
  au:au():event("TermOpen"):callback(function()
    opt_local.bufhidden = "hide"
    opt_local.number = false
  end)

  au:au():event("CmdLineEnter"):command "set nosmartcase"
  au:au():event("CmdLineLeave"):command "set smartcase"
  au:au():event("CmdLineEnter"):pattern([[/,\?]]):command ":set hlsearch"
  au:au():event("CmdLineLeave"):pattern([[/,\?]]):command ":set nohlsearch"
end)
