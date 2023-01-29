-- Disable some built-in plugins we don't want
local disabled_built_ins = {
  'gzip',
  -- 'man',
  'matchit',
  'matchparen',
  'shada_plugin',
  'tarPlugin',
  'tar',
  'zipPlugin',
  'zip',
  'netrwPlugin',
}

for _, plugin in ipairs(disabled_built_ins) do
  vim.g['loaded_' .. plugin] = 1
end

-- disable currently unused providers (see :h provider)
local disabled_providers = {
  'python3',
  'perl',
  'node',
  'ruby',
}

for _, lang in ipairs(disabled_providers) do
  vim.api.nvim_set_var('loaded_' .. lang .. '_provider', 0)
end

local diagnostics = require('baggiponte.utils.icons').icons.diagnostics

for type, icon in pairs(diagnostics) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- [[ Leader ]]
-- It's a good idea to set this early in your config, because otherwise if you have
-- any mappings you set BEFORE doing this, they will be set to the OLD leader.
vim.g.mapleader = ' '

-- Check :h nvim-defaults first!
-- [[ Sidebar ]]
vim.opt.number = true -- Make relative line numbers default
vim.opt.relativenumber = true
vim.opt.signcolumn = 'yes' -- Side column to display signs, e.g. git added/changed lines

-- [[ Tabs]]
-- smarttab enabled by default
vim.opt.expandtab = true
vim.opt.tabstop = 2 -- Number of spaces that a <Tab> in the file counts for
vim.opt.shiftwidth = 2 -- Number of spaces to use for each step of (auto)indent

-- [[ Context ]]
vim.opt.cursorline = true -- Highlight line where the cursor is
vim.opt.showmatch = true -- Highlight matching parentheses

vim.opt.linebreak = true -- Wrap lines
vim.opt.breakindent = true -- Indent wrapped lines

-- [[ Search ]]
vim.opt.hlsearch = false -- Highlight all matching patterns
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.scrolloff = 8 -- Minimal number of screen lines to keep above and below the cursor.

-- [[ Internals ]]
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = vim.fn.stdpath('cache') .. '/undodir'
vim.opt.undofile = true

vim.opt.updatetime = 50 -- Decrease update time.

-- [[ Clipboard ]]
-- vim.opt.clipboard:append('unnamedplus') -- Use system clipboard

-- [[ Colors ]]
vim.opt.termguicolors = true -- 256 colors terminal

-- [[ Splits ]]
vim.opt.splitright = true -- bool: Place new window to right of current one
vim.opt.splitbelow = true -- bool: Place new window below the current one
