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
