local config = {}

config.sonokai = function()
    local sonokai_options = {
        sonokai_style = 'atlantis',
        sonokai_enable_italic = 1,
        sonokai_disable_italic_comment = 1,
        sonokai_better_performance = 1
    }

    for option, value in pairs(sonokai_options) do vim.g[option] = value end

    vim.cmd('colorscheme sonokai')
end

config.colorizer = function()
    require'colorizer'.setup(
      {'*'}, {rgb_fn = true, hsl_fn = true, css = true, css_fn = true, mode = 'background'}
    )

end

config.devicon =
  function() require('nvim-web-devicons').setup({default = true}) end

config.lualine = function()

    require('lualine').setup {
        options = {
            icons_enabled = true,
            theme = 'auto',
            component_separators = {left = '', right = ''},
            section_separators = {left = '', right = ''},
            disabled_filetypes = {},
            always_divide_middle = true,
            globalstatus = true
        },
        sections = {
            lualine_a = {'mode'},
            lualine_b = {
                'branch',
                'diff',
                {'diagnostics', sources = {'nvim_diagnostic'}, update_in_insert = true}
            },
            lualine_c = {'filename'},
            lualine_x = {'encoding', 'fileformat', 'filetype'},
            lualine_y = {'progress'},
            lualine_z = {'location'}
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {'filename'},
            lualine_x = {'location'},
            lualine_y = {},
            lualine_z = {}
        },
        -- tabline = {
        --   lualine_a = { 'buffers' },
        --   lualine_b = {},
        --   lualine_c = {},
        --   lualine_x = {},
        --   lualine_y = {},
        --   lualine_z = { 'tabs' }
        -- },
        extensions = {'quickfix', 'nerdtree'}
    }

end

config.bufferline = function()

    local icons = require('jz.config.icons')

    require('bufferline').setup(
      {
          offsets = {{filetype = 'NvimTree', text = '', padding = 1}},
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
          view = 'multiwindow',
          show_buffer_close_icons = true,
          separator_style = 'thin',
          always_show_bufferline = true,
          diagnostics = false,
          themable = true
      }
    )

end

config.blankline = function()

    require('indent_blankline').setup {
        indentLine_enabled = 1,
        char = '▏',
        filetype_exclude = {
            'help',
            'terminal',
            'alpha',
            'packer',
            'lspinfo',
            'TelescopePrompt',
            'TelescopeResults',
            'nvchad_cheatsheet',
            'lsp-installer',
            ''
        },
        buftype_exclude = {'terminal'},
        show_trailing_blankline_indent = false,
        show_first_indent_level = false,
        show_current_context = true
    }

end

config.vifm = function()


end

return config
