require('tmux')

-- Rex has no stdpath() and no plugin manager, so the companion is loaded
-- from Neovim's vim.pack install of rex-navigator.nvim.
local navigator = os.getenv('HOME') .. '/.local/share/nvim/site/pack/core/opt/rex-navigator.nvim'

local ok, err = pcall(function()
  dofile(navigator .. '/rex/navigator.lua').setup({ wrap = false })
end)
if not ok then
  rex.log('warn', 'rex-navigator not loaded: ' .. tostring(err))
end
