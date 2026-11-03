-- Tmux-style bindings live separately; keep other Rex configuration here.
require('tmux')

-- rex-navigator.nvim ships a Rex companion in its rex/ folder. Rex has no
-- stdpath() and no plugin manager, so point this at wherever your Neovim
-- plugin manager installed rex-navigator.nvim. To print it, run in Neovim:
--   vim.pack:  :lua print(vim.fn.stdpath('data') .. '/site/pack/core/opt/rex-navigator.nvim')
--   lazy.nvim: :lua print(vim.fn.stdpath('data') .. '/lazy/rex-navigator.nvim')
-- This config uses vim.pack, with XDG_DATA_HOME=~/.local/share (zsh/.zshenv).
local navigator = os.getenv('HOME') .. '/.local/share/nvim/site/pack/core/opt/rex-navigator.nvim'

-- A missing plugin logs a warning instead of aborting the rest of this file.
local ok, err = pcall(function()
  dofile(navigator .. '/rex/navigator.lua').setup({ wrap = false })
end)
if not ok then
  rex.log('warn', 'rex-navigator not loaded: ' .. tostring(err))
end
