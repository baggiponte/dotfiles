---@param mode string|string[]
---@param lhs string
---@param rhs string|function
---@param desc string
local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { desc = desc, silent = true })
end

-- Registers
map({ 'n', 'v' }, 'x', '"_x', 'Delete a character without copying it')
map('x', '<leader>p', [["_dP]], 'Paste over a selection without copying it')
map({ 'n', 'v', 'o' }, 'gy', '"+y', 'Yank to the system clipboard')

-- Treesitter node selection is built in since 0.12 (Visual mode): an/in
-- select the parent/child node, ]n/[n move between nodes.

-- Inside the buffer: keep the cursor centred while jumping around.
map('', 'H', '^', 'Go to the beginning of the line')
map('', 'L', '$', 'Go to the end of the line')
map('n', 'n', 'nzz', 'Next match, centred')
map('n', 'N', 'Nzz', 'Previous match, centred')
map('n', '<C-u>', '<C-u>zz', 'Half a page up, centred')
map('n', '<C-d>', '<C-d>zz', 'Half a page down, centred')

-- Windows
map('n', '<C-h>', '<C-w>h', 'Focus the window to the left')
map('n', '<C-j>', '<C-w>j', 'Focus the window below')
map('n', '<C-k>', '<C-w>k', 'Focus the window above')
map('n', '<C-l>', '<C-w>l', 'Focus the window to the right')

-- Files
map('n', '<leader>q', '<cmd>q<CR>', 'Quit the window')
map('n', '<leader>w', '<cmd>w<CR>', 'Write the buffer')

-- :Undotree ships as an optional built-in plugin since 0.12.
vim.cmd.packadd('nvim.undotree')
map('n', '<leader>u', '<cmd>Undotree<CR>', 'Undotree: toggle')
