-- see: https://github.com/nanotee/nvim-lua-guide#api-functions

-- [[ Registers (") ]]

-- J appends the line after to the current one
-- vim.keymap.set("n", "J", "mzJ`z") -- this remap makes the cursor stay in place

vim.keymap.set('n', 'x', '"_x', { desc = 'Delete a character without copying into register' })
vim.keymap.set({ 'n', 'v' }, '<leader>d', [["_d]], { desc = 'Delete and send to the null register' })
vim.keymap.set('x', '<leader>p', [["_dP]], { desc = 'do not override register when pasting over an object' })

-- copy from system clipboard
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]], { desc = 'Yank and send to the system clipboard' })
vim.keymap.set('n', '<leader>Y', [["+Y]], { desc = 'Yank and send to the system clipboard' })

-- [[ Movements ]]

-- inside the buffer
vim.keymap.set('', 'H', '^', { desc = 'go to the beginning of the line' })
vim.keymap.set('', 'L', '$', { desc = 'go to the end of the line' })
vim.keymap.set('n', 'n', 'nzz', { desc = 'search and center screen', silent = true, noremap = true })
vim.keymap.set('n', 'N', 'Nzz', { desc = 'search and center screen', silent = true, noremap = true })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'go up half a page and center screen', silent = true, noremap = true })
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

-- move lines up and down in visual mode
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move the line up' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move the line down' })

-- [[ Save and exit files ]]
vim.keymap.set('n', '<leader>q', '<cmd>q<CR>', { desc = '[w]rite current buffer', silent = true, noremap = true })
vim.keymap.set('n', '<leader>Q', '<cmd>q!<CR>', { desc = '[w]rite current buffer', silent = true, noremap = true })
vim.keymap.set('n', '<leader>w', '<cmd>w<CR>', { desc = '[w]rite current buffer', silent = true, noremap = true })
vim.keymap.set('n', '<leader>W', '<cmd>wa<CR>', { desc = '[w]rite [a]ll buffers', silent = true, noremap = true })
vim.keymap.set(
  'n',
  '<leader>x',
  '<cmd>w | so %<CR>',
  { desc = 'Write and source current buffer', silent = true, noremap = true }
)
