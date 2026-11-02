-- Configure every plugin: one module per file in this folder. The colorscheme
-- goes first so nothing draws with the default colours.
require('baggiponte.plugins.colorscheme')

local dir = vim.fs.joinpath(vim.fn.stdpath('config'), 'lua', 'baggiponte', 'plugins')
local modules = {} ---@type string[]
for name, kind in vim.fs.dir(dir) do
  local module = kind == 'file' and name:match('^(.+)%.lua$')
  if module and module ~= 'init' and module ~= 'colorscheme' then
    table.insert(modules, module)
  end
end
table.sort(modules)

for _, module in ipairs(modules) do
  require('baggiponte.plugins.' .. module)
end
