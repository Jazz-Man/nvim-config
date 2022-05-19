local colorizer = prequire("colorizer")
local lualine = prequire('lualine')


local sonokai_options = {
  sonokai_style = "atlantis",
  sonokai_enable_italic = 1,
  sonokai_disable_italic_comment = 1,
  sonokai_better_performance = 1
}

for option, value in pairs(sonokai_options) do
  nvim.g[option] = value

end

nvim.command("colorscheme sonokai")


if colorizer then

  colorizer.setup(
    {
      "*"
    },
    {
      rgb_fn = true,
      hsl_fn = true,
      css = true,
      css_fn = true,
      mode = "background"
    }
  )

end



if lualine then


  lualine.setup {
    options = {
      icons_enabled = true,
      theme = 'auto',
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      disabled_filetypes = {},
      always_divide_middle = true,
      globalstatus = false
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch', 'diff', 'diagnostics' },
      lualine_c = { 'filename' },
      lualine_x = { 'encoding', 'fileformat', 'filetype' },
      lualine_y = { 'progress' },
      lualine_z = { 'location' }
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { 'filename' },
      lualine_x = { 'location' },
      lualine_y = {},
      lualine_z = {}
    },
    tabline = {},
    extensions = { "quickfix" }
  }
end
