-- see: https://github.com/nanotee/nvim-lua-guide#api-functions

local opts = { silent = true, noremap = true }

-- delete single character without copying into register
vim.keymap.set('n', 'x', '"_x')

-- [[ Move across buffers ]]
vim.keymap.set('n', '<c-h>', '<c-w>h', opts)
vim.keymap.set('n', '<c-j>', '<c-w>j', opts)
vim.keymap.set('n', '<c-k>', '<c-w>k', opts)
vim.keymap.set('n', '<c-l>', '<c-w>l', opts)

-- [[ Create splits ]]
vim.keymap.set('n', '<leader>v', function()
  vim.cmd([[vsp %:p:h]])
  require('telescope.builtin').find_files({ path = '%:p:h ' })
end, opts)

vim.keymap.set('n', '<leader>V', function()
  vim.cmd([[sp %:p:h]])
  require('telescope.builtin').find_files({ path = '%:p:h ' })
end, opts)

-- [[ Save and exit files ]]
vim.keymap.set('n', '<leader>w', '<cmd>w<CR>', opts) -- save file
vim.keymap.set('n', '<leader>W', '<cmd>wa<CR>', opts) -- save file
vim.keymap.set('n', 'q', '<cmd>Sayonara<CR>', opts) -- quit buffer
vim.keymap.set('n', 'Q', '<cmd>Sayonara!<CR>', opts) -- quit all buffers

-- [[ General remaps ]]
vim.keymap.set('', 'H', '^') -- remap go to the beginning of the line
vim.keymap.set('', 'L', '$') -- remap go to the end of the line
