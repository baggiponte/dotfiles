require('dap-python').setup(vim.fn.stdpath('data') .. '/mason/packages/debugpy/venv/bin/python')
require('dap-python').test_runner = 'pytest'

local opts = { silent = true, noremap = true }

vim.keymap.set('n', '<F5>', require('dap').continue, opts)
vim.keymap.set('n', '<leader>b', require('dap').toggle_breakpoint, opts)
