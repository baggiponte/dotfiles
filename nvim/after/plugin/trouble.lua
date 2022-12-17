local trouble = require('trouble')

trouble.setup({
  position = 'right',
})

vim.keymap.set(
  'n',
  '<leader>sw',
  '<cmd>TroubleToggle workspace_diagnostics<cr>',
  { desc = '[s]how [w]orkspace diagnostics' }
)
vim.keymap.set(
  'n',
  '<leader>sd',
  '<cmd>TroubleToggle document_diagnostics<cr>',
  { desc = '[s]how [d]ocument diagnostics' }
)
vim.keymap.set('n', '<leader>sl', '<cmd>TroubleToggle loclist<cr>', { desc = '[s]how [l]oclist diagnostics' })
vim.keymap.set('n', '<leader>sq', '<cmd>TroubleToggle quickfix<cr>', { desc = '[s]how [q]uickfix diagnostics' })
