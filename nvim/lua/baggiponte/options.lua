-- Configure diagnostics
vim.diagnostic.config({
  virtual_text = { prefix = '' },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = ' ',
      [vim.diagnostic.severity.WARN] = ' ',
      [vim.diagnostic.severity.HINT] = ' ',
      [vim.diagnostic.severity.INFO] = ' ',
    },
  },
})

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

-- [[ Leader ]]
-- It's a good idea to set this early in your config, because otherwise if you have
-- any mappings you set BEFORE doing this, they will be set to the OLD leader.
vim.g.mapleader = ' '
vim.g.maplocalleader = ';'

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

-- [[ Splits ]]
vim.opt.splitright = true -- bool: Place new window to right of current one
vim.opt.splitbelow = true -- bool: Place new window below the current one
