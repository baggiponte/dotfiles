-- [[ Leader ]]
-- It's a good idea to set this early in your config, because otherwise if you have
-- any mappings you set BEFORE doing this, they will be set to the OLD leader.
vim.g.mapleader = ' '

-- Disable some built-in plugins we don't want
local disabled_built_ins = {
  'gzip',
  'man',
  'matchit',
  'matchparen',
  'shada_plugin',
  'tarPlugin',
  'tar',
  'zipPlugin',
  'zip',
}

for _, plugin in ipairs(disabled_built_ins) do
  vim.g['loaded_' .. plugin] = 1
end

-- Check :h nvim-defaults first!
-- [[ Sidebar ]]
vim.opt.number = true -- Make relative line numbers default
vim.opt.relativenumber = true
vim.opt.signcolumn = 'yes' -- Side column to display signs, e.g. git added/changed lines

-- [[ Context ]]
vim.opt.cursorline = true -- Highlight line where the cursor is
vim.opt.showmatch = true -- Highlight matching parentheses
vim.opt.breakindent = true -- Enable break indent.
vim.opt.linebreak = true

-- [[ Search ]]
vim.opt.hlsearch = false -- Set highlight on search. This will remove the highlight after searching for text.
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.scrolloff = 8 -- Minimal number of screen lines to keep above and below the cursor.

-- [[ Internals ]]
vim.opt.undofile = true -- Store undos to reapply them even after file is closed
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.lazyredraw = true -- Prevents redrawing the buffer, e.g. when doing macros
vim.opt.updatetime = 250 -- Decrease update time.

-- [[ Clipboard ]]
vim.opt.clipboard:append('unnamedplus') -- Use system clipboard

-- [[ Colors ]]
vim.opt.termguicolors = true -- 256 colors terminal

-- [[ Splits ]]
vim.opt.splitright = true -- bool: Place new window to right of current one
vim.opt.splitbelow = true -- bool: Place new window below the current one

-- [[ Highlight on yank ]]
vim.api.nvim_exec(
  [[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]],
  false
)
