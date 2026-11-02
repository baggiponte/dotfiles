-- Local checkout, put on the runtimepath by baggiponte.pack when present.
local ok, rex = pcall(require, 'rex-navigator')
if ok then
  rex.setup({})
end
