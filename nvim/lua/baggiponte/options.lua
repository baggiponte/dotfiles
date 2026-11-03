-- Set before any mapping is defined: a mapping captures <leader> when it's created.
vim.g.mapleader = ' '

-- Providers this config doesn't use (see :h provider): skips searching for
-- python3, node, ... at startup.
for _, provider in ipairs({ 'python3', 'perl', 'node', 'ruby' }) do
  vim.g['loaded_' .. provider .. '_provider'] = 0
end

-- Built-in plugins this config doesn't use: their plugin/ files bail out
-- early when these are set, which saves startup time.
for _, plugin in ipairs({
  'gzip',
  'matchit',
  'matchparen',
  'netrw',
  'netrwPlugin',
  'shada_plugin',
  'tarPlugin',
  'tutor_mode_plugin',
  'zipPlugin',
}) do
  vim.g['loaded_' .. plugin] = 1
end

-- 'cmdheight' and ui2 are set up by neat's cmdline module (plugins/neat.lua).

-- Only options that differ from Neovim's defaults (see :h nvim-defaults).
vim.o.winborder = 'rounded'

vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = 'yes'
vim.o.cursorline = true
vim.o.showmatch = true
vim.o.scrolloff = 8

vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2

-- Wrap long lines at word boundaries, keeping their indent.
vim.o.linebreak = true
vim.o.breakindent = true

vim.o.hlsearch = false
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.splitright = true
vim.o.splitbelow = true

-- Persistent undo instead of swap files. The undo history lives in the cache
-- folder rather than the default state folder.
vim.o.swapfile = false
vim.o.undofile = true
vim.o.undodir = vim.fn.stdpath('cache') .. '/undodir'

vim.o.updatetime = 50
