require('toggleterm').setup({
  direction = 'float',
  float_opts = {
    border = 'curved',
  },
})

vim.keymap.set('t', '<esc>', [[<C-\><C-n>]])
vim.keymap.set('t', '<C-esc>', [[<C-\><C-n><cmd>q<CR>]])
