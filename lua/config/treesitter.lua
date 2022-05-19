local treesitter = prequire("nvim-treesitter.configs")

local comment = prequire("Comment")


if treesitter then


  vim.wo.foldmethod = "expr"
  vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

  treesitter.setup {
    ensure_installed = "all",
    highlight = {
      enable = true, -- false will disable the whole extension
      additional_vim_regex_highlighting = false,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        -- mappings for incremental selection (visual mappings)
        init_selection = "gss", -- maps in normal mode to init the node/scope selection
        scope_incremental = "gsu", -- increment to the upper scope (as defined in locals.scm)
        node_incremental = "gsi", -- increment to the upper named parent
        node_decremental = "gsd" -- decrement to the previous node
      }
    },
    indent = {
      enable = true
    },
    refactor = {
      highlight_defintions = {
        enable = true,
        clear_on_cursor_move = true,
      },
      highlight_current_scope = {
        enable = false -- Breaks virtual text
      },
      smart_rename = {
        enable = true,
        -- keymaps = {
        --   smart_rename = "grr",
        -- },
      },
      navigation = {
        enable = true,
        -- keymaps = {
        --   goto_definition = "gnd", -- mapping togo to definition of symbol under cursor
        --   list_definitions = "gnD", -- mapping to list all definitions in current file
        --   goto_next_usage = "<c-n>",
        --   goto_previous_usage = "<c-p>"
        -- }
      }
    },
    textobjects = {
      select = {
        enable = true,
        -- keymaps = {
        --   -- You can use the capture groups defined in textobjects.scm
        --   ["af"] = "@function.outer",
        --   ["if"] = "@function.inner",
        --   ["ac"] = "@class.outer",
        --   ["ic"] = "@class.inner"
        -- }
      },
      swap = {
        enable = true,
        -- swap_next = {
        --   ["<leader>a"] = "@parameter.inner"
        -- },
        -- swap_previous = {
        --   ["<leader>A"] = "@parameter.inner"
        -- }
      },
      move = {
        enable = true,
        set_jumps = true,
        -- goto_next_start = {
        --   ["]f"] = "@function.outer",
        --   ["}c"] = "@class.outer"
        -- },
        -- goto_next_end = {
        --   ["]F"] = "@function.outer",
        --   ["}C"] = "@class.outer"
        -- },
        -- goto_previous_start = {
        --   ["[f"] = "@function.outer",
        --   ["{c"] = "@class.outer"
        -- },
        -- goto_previous_end = {
        --   ["[F"] = "@function.outer",
        --   ["{C"] = "@class.outer"
        -- }
      },
      lsp_interop = {
        enable = true,
        border = "single",
        -- peek_definition_code = {
        --   ["df"] = "@function.outer",
        --   ["dF"] = "@class.outer",
        -- },
      },
    },
    context_commentstring = {
      enable = true
    },
    playground = {
      enable = true
    }
  }


  if comment then
    comment.setup {
      pre_hook = function(ctx)
        local utils = require "Comment.utils"

        local location = nil
        if ctx.ctype == utils.ctype.block then
          location = require("ts_context_commentstring.utils").get_cursor_location()
        elseif ctx.cmotion == utils.cmotion.v or ctx.cmotion == utils.cmotion.V then
          location = require("ts_context_commentstring.utils").get_visual_start_location()
        end

        return require("ts_context_commentstring.internal").calculate_commentstring {
          key = ctx.ctype == utils.ctype.line and "__default" or "__multiline",
          location = location,
        }
      end,
    }

  end
end
