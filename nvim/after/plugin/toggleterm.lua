local Terminal = require('toggleterm.terminal').Terminal
local lazygit = Terminal:new({ cmd = 'lazygit', hidden = true, direction = 'float' }) -- see: https://github.com/akinsho/toggleterm.nvim#custom-terminals

require('toggleterm').setup({
  direction = 'float',
  float_opts = {
    border = 'curved',
  },
})

local opts = { silent = true, noremap = true }
vim.keymap.set('n', '<leader>tt', function()
  vim.cmd('ToggleTerm ' .. 'dir=' .. vim.fn.expand('%:p:h'))
end, opts)
vim.keymap.set('t', '<esc><esc>', [[<C-\><C-n><cmd>q<CR>]], opts)

vim.keymap.set('n', '<leader>lg', function()
  lazygit:toggle()
end, { noremap = true, silent = true })
