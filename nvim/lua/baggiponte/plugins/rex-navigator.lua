-- local plugin, put on the runtimepath by baggiponte.pack
local ok, rex = pcall(require, 'rex-navigator')
if ok then
  rex.setup({})
end
