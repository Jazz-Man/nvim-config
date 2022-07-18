_G.dump = function( ... )
  for _, v in ipairs { ... } do print(vim.inspect(v, { depth = math.huge })) end
end
