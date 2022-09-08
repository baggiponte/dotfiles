-- see: https://github.com/nanotee/nvim-lua-guide#api-functions

local opts = { silent = true, noremap = true }

-- [[ Move across buffers ]]
vim.keymap.set('n', '<c-h>', '<c-w>h', opts)
vim.keymap.set('n', '<c-j>', '<c-w>j', opts)
vim.keymap.set('n', '<c-k>', '<c-w>k', opts)
vim.keymap.set('n', '<c-l>', '<c-w>l', opts)

-- [[ Save and exit files ]]
vim.keymap.set('n', '<leader>w', '<cmd>w<CR>', opts) -- save file
vim.keymap.set('n', '<leader>q', '<cmd>bd<CR>', opts) -- quit buffer
vim.keymap.set('n', '<leader>Q', '<cmd>q<CR>', opts) -- quit all buffers
vim.keymap.set('n', '<leader>pv', '<cmd>Ex<CR>', opts) -- launch netrw

-- [[ General remaps ]]
vim.keymap.set('', 'H', '^') -- remap go to the beginning of the line
vim.keymap.set('', 'L', '$') -- remap go to the end of the line
