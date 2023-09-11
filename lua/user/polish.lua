local function autocmd_setup()
  local au = require "lua.jz.utils.autocmd"

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
end

return function()
  autocmd_setup()
  local function yaml_ft(path, bufnr)
    -- get content of buffer as string
    local content = vim.filetype.getlines(bufnr)
    if type(content) == "table" then content = table.concat(content, "\n") end

    -- check if file is in roles, tasks, or handlers folder
    local path_regex = vim.regex "(tasks\\|roles\\|handlers)/"
    if path_regex and path_regex:match_str(path) then return "yaml.ansible" end
    -- check for known ansible playbook text and if found, return yaml.ansible
    local regex = vim.regex "hosts:\\|tasks:"
    if regex and regex:match_str(content) then return "yaml.ansible" end

    -- return yaml if nothing else
    return "yaml"
  end

  vim.filetype.add {
    extension = {
      yml = yaml_ft,
      yaml = yaml_ft,
    },
  }
end
