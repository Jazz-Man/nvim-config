local res, luasnip = pcall(require, "luasnip")
if not res then
  return
end



require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_snipmate").lazy_load()
require("luasnip.loaders.from_lua").lazy_load()

luasnip.config.set_config({
  history = false,
  -- Update more often, :h events for more info.
  updateevents = "TextChanged,TextChangedI"
})
