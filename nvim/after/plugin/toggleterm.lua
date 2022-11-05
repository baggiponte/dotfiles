local Terminal = require('toggleterm.terminal').Terminal
local lazygit = Terminal:new({ cmd = 'lazygit', hidden = true, direction = 'float' })

function _lazygit_toggle()
  lazygit:toggle()
end

require('toggleterm').setup({
  direction = 'float',
  float_opts = {
    border = 'curved',
  },
})

local opts = { silent = true, noremap = true }
vim.keymap.set('n', '<leader>tt', '<cmd>ToggleTerm<CR>', opts)
vim.keymap.set('t', '<esc><esc>', [[<C-\><C-n><cmd>q<CR>]], opts)

vim.api.nvim_set_keymap('n', '<leader>lg', '<cmd>lua _lazygit_toggle()<CR>', { noremap = true, silent = true })
