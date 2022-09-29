-- Lua
local opt = { silent = true, noremap = true }
vim.keymap.set('n', '<leader>zz', '<cmd>TroubleToggle<cr>', opt)
vim.keymap.set('n', '<leader>zw', '<cmd>TroubleToggle workspace_diagnostics<cr>', opt)
vim.keymap.set('n', '<leader>zd', '<cmd>TroubleToggle document_diagnostics<cr>', opt)
vim.keymap.set('n', '<leader>zl', '<cmd>TroubleToggle loclist<cr>', opt)
vim.keymap.set('n', '<leader>zq', '<cmd>TroubleToggle quickfix<cr>', opt)
vim.keymap.set('n', 'gR', '<cmd>TroubleToggle lsp_references<cr>', opt)
