-- see: https://github.com/nanotee/nvim-lua-guide#api-functions

-- [[ Registers (") ]]

-- J appends the line after to the current one
-- vim.keymap.set("n", "J", "mzJ`z") -- this remap makes the cursor stay in place

vim.keymap.set({ 'n', 'v' }, 'x', '"_x', { desc = 'Delete a character without copying into register' })
vim.keymap.set('x', '<leader>p', [["_dP]], { desc = 'do not override register when pasting over an object' })

-- copy from system clipboard
vim.keymap.set({ 'n', 'v', 'o' }, 'gy', '"+y', { desc = 'Yank and send to the system clipboard' })
-- not needed: you can cmd+V
-- vim.keymap.set({ 'n', 'v', 'o' }, 'gp', '"+p', { desc = 'Paste from the system clipboard' })

-- [[ Movements ]]

-- inside the buffer
vim.keymap.set('', 'H', '^', { desc = 'Go to the beginning of the line' })
vim.keymap.set('', 'L', '$', { desc = 'Go to the end of the line' })
vim.keymap.set('n', 'n', 'nzz', { desc = 'Search and center screen', silent = true, noremap = true })
vim.keymap.set('n', 'N', 'Nzz', { desc = 'Search and center screen', silent = true, noremap = true })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Go up half a page and center screen', silent = true, noremap = true })
vim.keymap.set(
  'n',
  '<C-d>',
  '<C-d>zz',
  { desc = 'go down half a page and center screen', silent = true, noremap = true }
)

-- across buffers
vim.keymap.set('n', '<c-h>', '<c-w>h', { desc = 'Move focus to the left window', silent = true, noremap = true })
vim.keymap.set('n', '<c-j>', '<c-w>j', { desc = 'Move focus to the window above', silent = true, noremap = true })
vim.keymap.set('n', '<c-k>', '<c-w>k', { desc = 'Move focus to the window below', silent = true, noremap = true })
vim.keymap.set('n', '<c-l>', '<c-w>l', { desc = 'Move focus to the right window', silent = true, noremap = true })

-- [[ Save and exit files ]]
vim.keymap.set('n', '<leader>q', '<cmd>q<CR>', { desc = 'write current buffer', silent = true, noremap = true })
vim.keymap.set('n', '<leader>w', '<cmd>w<CR>', { desc = 'write current buffer', silent = true, noremap = true })
