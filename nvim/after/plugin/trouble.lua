local trouble = require('trouble')

trouble.setup({
  position = 'right',
})

local opts = { silent = true, noremap = true }

vim.keymap.set('n', '<leader>dd', '<cmd>TroubleToggle<cr>', opts) -- <leader>dD is telescope diagnostics
vim.keymap.set('n', '<leader>dw', '<cmd>TroubleToggle workspace_diagnostics<cr>', opts)
vim.keymap.set('n', '<leader>dD', '<cmd>TroubleToggle document_diagnostics<cr>', opts)
vim.keymap.set('n', '<leader>dl', '<cmd>TroubleToggle loclist<cr>', opts)
vim.keymap.set('n', '<leader>dq', '<cmd>TroubleToggle quickfix<cr>', opts)
