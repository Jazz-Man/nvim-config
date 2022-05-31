local telescope = require("telescope")
-- local previewers = require("telescope.previewers")
-- local Job = require("plenary.job")
local actions = require "telescope.actions"
local themes = require "telescope.themes"
-- local utils = require "jz.utils"


local horizontal_preview_width = function(_, cols, _)
  if cols > 200 then
    return math.floor(cols * 0.6)
  else
    return math.floor(cols * 0.5)
  end
end


telescope.setup {
  defaults = {

    path_display = { "smart" },
    layout_strategy = "flex",
    file_ignore_patterns = {
      "node_modules",
      "vendor",
      ".pyc"
    },
    layout_config = {
      prompt_position = "top",
      width = 0.9,
      horizontal = {
        preview_width = horizontal_preview_width,
      },
      vertical = {
        -- width_padding = 0.05,
        -- height_padding = 1,
        width = 0.75,
        height = 0.85,
        preview_height = 0.4,
        mirror = true,
      },
    },
    sorting_strategy = "ascending",
    selection_strategy = "closest",

    dynamic_preview_title = true,

    mappings = {
      i = {
        ["<C-n>"] = actions.cycle_history_next,
        ["<C-p>"] = actions.cycle_history_prev,

        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,

        ["<C-c>"] = actions.close,

        ["<Down>"] = actions.move_selection_next,
        ["<Up>"] = actions.move_selection_previous,

        ["<CR>"] = actions.select_default,
        ["<C-x>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,

        ["<C-u>"] = actions.preview_scrolling_up,
        ["<C-d>"] = actions.preview_scrolling_down,

        ["<PageUp>"] = actions.results_scrolling_up,
        ["<PageDown>"] = actions.results_scrolling_down,

        ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
        ["<C-l>"] = actions.complete_tag,
        ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
      },

      n = {
        ["<esc>"] = actions.close,
        ["<CR>"] = actions.select_default,
        ["<C-x>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,

        ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

        ["j"] = actions.move_selection_next,
        ["k"] = actions.move_selection_previous,
        ["H"] = actions.move_to_top,
        ["M"] = actions.move_to_middle,
        ["L"] = actions.move_to_bottom,

        ["<Down>"] = actions.move_selection_next,
        ["<Up>"] = actions.move_selection_previous,
        ["gg"] = actions.move_to_top,
        ["G"] = actions.move_to_bottom,

        ["<C-u>"] = actions.preview_scrolling_up,
        ["<C-d>"] = actions.preview_scrolling_down,

        ["<PageUp>"] = actions.results_scrolling_up,
        ["<PageDown>"] = actions.results_scrolling_down,

        ["?"] = actions.which_key,
      },
    },
  },
  pickers = {
    -- Default configuration for builtin pickers goes here:
    -- picker_name = {
    --   picker_config_key = value,
    --   ...
    -- }
    -- Now the picker_config_key will be applied every time you call this
    -- builtin picker
  },
  extensions = {
    ["ui-select"] = {
      themes.get_cursor(),
    },
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = "smart_case", -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    },
    packer = {
      theme = "ivy",
      layout_config = {
        height = .5
      }
    }
  },
}


require('telescope').load_extension('fzf')
require('telescope').load_extension('packer')
require("telescope").load_extension("ui-select")

local M = {}


function M.builtin()
  require("telescope.builtin").builtin()
end

function M.buffers()
  require("telescope.builtin").buffers {
    attach_mappings = function(_, map)
      map('i', '<c-x>', actions.delete_buffer)
      map('n', '<c-x>', actions.delete_buffer)
      return true
    end,
  }
end

function M.find_files(opts)
  opts = opts or {}
  opts = vim.tbl_deep_extend("force", {
    find_command = {
      "fd",
      "--type=f",
      "--hidden",
      "--follow",
      "--exclude=.git",
      "--strip-cwd-prefix"
    },
  }, opts)
  require("telescope.builtin").fd(opts)

end

function M.edit_neovim()
  M.find_files {
    prompt_title = "< VimRC >",
    path_display = { "absolute" },
    cwd = "~/.config/nvim",
  }
end

return setmetatable({}, {
  __index = function(_, k)
    -- reloader()

    if M[k] then
      return M[k]
    else
      return require("telescope.builtin")[k]
    end
  end,
})
