-- Tmux-style bindings live separately; keep other Rex configuration here.
require('tmux')

-- Companion to rex-navigator.nvim, from the copy vim.pack installs for Neovim
-- (stdpath('data') is ~/.local/share/nvim, see zsh/.zshenv). Rex has no
-- stdpath, and a missing plugin must not abort the rest of this file.
local navigator = os.getenv('HOME') .. '/.local/share/nvim/site/pack/core/opt/rex-navigator.nvim'
local ok, err = pcall(function()
  dofile(navigator .. '/rex/navigator.lua').setup({ wrap = false })
end)
if not ok then
  rex.log('warn', 'rex-navigator not loaded: ' .. tostring(err))
end
