" Automatically generated packer.nvim plugin loader code

lua << END
local plugins = {
  ["packer.nvim"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/Users/vasilsokolik/.local/share/nvim/site/pack/packer/opt/packer.nvim"
  },
  ["vim-airline"] = {
    config = { "\27LJ\1\2ï\2\0\0\3\0\v\0\0314\0\0\0007\0\1\0007\0\2\0%\1\3\0'\2\1\0>\0\3\0014\0\0\0007\0\1\0007\0\2\0%\1\4\0%\2\5\0>\0\3\0014\0\0\0007\0\1\0007\0\2\0%\1\6\0%\2\a\0>\0\3\0014\0\0\0007\0\1\0007\0\2\0%\1\b\0%\2\t\0>\0\3\0014\0\0\0007\0\1\0007\0\2\0%\1\n\0'\2\1\0>\0\3\1G\0\1\0.airline#extensions#tabline#buffer_nr_show\25unique_tail_improved)airline#extensions#tabline#formatter\6|,airline#extensions#tabline#left_alt_sep\6 (airline#extensions#tabline#left_sep'airline#extensions#tabline#enabled\17nvim_set_var\bapi\bvim\0" },
    loaded = false,
    only_sequence = true,
    only_setup = true,
    path = "/Users/vasilsokolik/.local/share/nvim/site/pack/packer/opt/vim-airline"
  }
}

local function handle_bufread(names)
  for _, name in ipairs(names) do
    local path = plugins[name].path
    for _, dir in ipairs({ 'ftdetect', 'ftplugin', 'after/ftdetect', 'after/ftplugin' }) do
      if #vim.fn.finddir(dir, path) > 0 then
        vim.cmd('doautocmd BufRead')
        return
      end
    end
  end
end

_packer_load = nil

local function handle_after(name, before)
  local plugin = plugins[name]
  plugin.load_after[before] = nil
  if next(plugin.load_after) == nil then
    _packer_load({name}, {})
  end
end

_packer_load = function(names, cause)
  local some_unloaded = false
  for _, name in ipairs(names) do
    if not plugins[name].loaded then
      some_unloaded = true
      break
    end
  end

  if not some_unloaded then return end

  local fmt = string.format
  local del_cmds = {}
  local del_maps = {}
  for _, name in ipairs(names) do
    if plugins[name].commands then
      for _, cmd in ipairs(plugins[name].commands) do
        del_cmds[cmd] = true
      end
    end

    if plugins[name].keys then
      for _, key in ipairs(plugins[name].keys) do
        del_maps[key] = true
      end
    end
  end

  for cmd, _ in pairs(del_cmds) do
    vim.cmd('silent! delcommand ' .. cmd)
  end

  for key, _ in pairs(del_maps) do
    vim.cmd(fmt('silent! %sunmap %s', key[1], key[2]))
  end

  for _, name in ipairs(names) do
    if not plugins[name].loaded then
      vim.cmd('packadd ' .. name)
      vim._update_package_paths()
      if plugins[name].config then
        for _i, config_line in ipairs(plugins[name].config) do
          loadstring(config_line)()
        end
      end

      if plugins[name].after then
        for _, after_name in ipairs(plugins[name].after) do
          handle_after(after_name, name)
          vim.cmd('redraw')
        end
      end

      plugins[name].loaded = true
    end
  end

  handle_bufread(names)

  if cause.cmd then
    local lines = cause.l1 == cause.l2 and '' or (cause.l1 .. ',' .. cause.l2)
    vim.cmd(fmt('%s%s%s %s', lines, cause.cmd, cause.bang, cause.args))
  elseif cause.keys then
    local keys = cause.keys
    local extra = ''
    while true do
      local c = vim.fn.getchar(0)
      if c == 0 then break end
      extra = extra .. vim.fn.nr2char(c)
    end

    if cause.prefix then
      local prefix = vim.v.count and vim.v.count or ''
      prefix = prefix .. '"' .. vim.v.register .. cause.prefix
      if vim.fn.mode('full') == 'no' then
        if vim.v.operator == 'c' then
          prefix = '' .. prefix
        end

        prefix = prefix .. vim.v.operator
      end

      vim.fn.feedkeys(prefix, 'n')
    end

    -- NOTE: I'm not sure if the below substitution is correct; it might correspond to the literal
    -- characters \<Plug> rather than the special <Plug> key.
    vim.fn.feedkeys(string.gsub(string.gsub(cause.keys, '^<Plug>', '\\<Plug>') .. extra, '<[cC][rR]>', '\r'))
  elseif cause.event then
    vim.cmd(fmt('doautocmd <nomodeline> %s', cause.event))
  elseif cause.ft then
    vim.cmd(fmt('doautocmd <nomodeline> %s FileType %s', 'filetypeplugin', cause.ft))
    vim.cmd(fmt('doautocmd <nomodeline> %s FileType %s', 'filetypeindent', cause.ft))
  end
end

-- Runtimepath customization

-- Pre-load configuration
-- Setup for: vim-airline
loadstring("\27LJ\1\2I\0\0\3\0\4\0\a4\0\0\0007\0\1\0007\0\2\0%\1\3\0)\2\2\0>\0\3\1G\0\1\0\18termguicolors\20nvim_set_option\bapi\bvim\0")()
vim.cmd("packadd vim-airline")
-- Post-load configuration
-- Config for: formatter.nvim
require [[config/formatter]]
-- Config for: nvim-lspconfig
require [[config/lsp]]
-- Config for: completion-nvim
loadstring("\27LJ\1\2É\1\0\0\2\0\6\0\0174\0\0\0007\0\1\0'\1\1\0:\1\2\0004\0\0\0007\0\1\0'\1\1\0:\1\3\0004\0\0\0007\0\1\0'\1\1\0:\1\4\0004\0\0\0007\0\1\0'\1\1\0:\1\5\0G\0\1\0!completion_enable_auto_paren$completion_matching_ignore_case\"completion_auto_change_source!completion_enable_auto_hover\6g\bvim\0")()
-- Config for: nvim-colorizer.lua
loadstring("\27LJ\1\2u\0\0\3\0\5\0\b4\0\0\0%\1\1\0>\0\2\0027\0\2\0003\1\3\0003\2\4\0>\0\3\1G\0\1\0\1\0\5\vcss_fn\2\vrgb_fn\2\tmode\15background\vhsl_fn\2\bcss\2\1\2\0\0\6*\nsetup\14colorizer\frequire\0")()
-- Config for: nvim-tree.lua
loadstring("\27LJ\1\2 \4\0\0\3\0\17\0C4\0\0\0007\0\1\0007\0\2\0%\1\3\0%\2\4\0>\0\3\0014\0\0\0007\0\1\0007\0\2\0%\1\5\0'\2(\0>\0\3\0014\0\0\0007\0\1\0007\0\2\0%\1\6\0003\2\a\0>\0\3\0014\0\0\0007\0\1\0007\0\2\0%\1\b\0'\2\1\0>\0\3\0014\0\0\0007\0\1\0007\0\2\0%\1\t\0'\2\1\0>\0\3\0014\0\0\0007\0\1\0007\0\2\0%\1\n\0'\2\1\0>\0\3\0014\0\0\0007\0\1\0007\0\2\0%\1\v\0'\2\1\0>\0\3\0014\0\0\0007\0\1\0007\0\2\0%\1\f\0'\2\0\0>\0\3\0014\0\0\0007\0\1\0007\0\2\0%\1\r\0'\2\1\0>\0\3\0014\0\0\0007\0\1\0007\0\2\0%\1\14\0%\2\15\0>\0\3\0014\0\0\0007\0\1\0007\0\2\0%\1\16\0'\2\1\0>\0\3\1G\0\1\0\22lua_tree_tab_open\a:~\"lua_tree_root_folder_modifier\20lua_tree_git_hl\27lua_tree_hide_dotfiles\28lua_tree_indent_markers\20lua_tree_follow\24lua_tree_auto_close\23lua_tree_auto_open\1\4\0\0\t.git\17node_modules\v.cache\20lua_tree_ignore\19lua_tree_width\tleft\18lua_tree_side\17nvim_set_var\bapi\bvim\0")()
-- Config for: vim-material
loadstring("\27LJ\1\2Á\1\0\0\3\0\n\0\0184\0\0\0007\0\1\0007\0\2\0%\1\3\0%\2\4\0>\0\3\0014\0\0\0007\0\1\0007\0\5\0%\1\6\0>\0\2\0014\0\0\0007\0\1\0007\0\a\0%\1\b\0%\2\t\0>\0\3\1G\0\1\0\rmaterial\18airline_theme\17nvim_set_var\29colorscheme vim-material\17nvim_command\tdark\15background\20nvim_set_option\bapi\bvim\0")()
-- Config for: nvim-treesitter
require [[config/treesitter]]
-- Conditional loads
-- Load plugins in order defined by `after`
vim._update_package_paths()
END

function! s:load(names, cause) abort
call luaeval('_packer_load(_A[1], _A[2])', [a:names, a:cause])
endfunction


" Command lazy-loads

" Keymap lazy-loads

augroup packer_load_aucmds
  au!
  " Filetype lazy-loads
  " Event lazy-loads
augroup END
