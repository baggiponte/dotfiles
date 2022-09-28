require('toggleterm').setup({
  direction = 'float',
  float_opts = {
    border = 'curved',
  },
})

local opts = { silent = true, noremap = true }
vim.keymap.set('n', '<leader>tt', '<cmd>ToggleTerm<CR>', opts)
vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
vim.keymap.set('t', '<C-esc>', [[<C-\><C-n><cmd>q<CR>]], opts)
