local dap, dapui, dappy = require('dap'), require('dapui'), require('dap-python')

-- configure nvim-dap-ui to work with nvim-dap
dapui.setup()

dap.listeners.after.event_initialized['dapui_config'] = function()
  dapui.open({})
end

dap.listeners.before.event_terminated['dapui_config'] = function()
  dapui.close({})
end

dap.listeners.before.event_exited['dapui_config'] = function()
  dapui.close({})
end

-- configure nvim-dap-python
dappy.setup(vim.fn.stdpath('data') .. '/mason/packages/debugpy/venv/bin/python')
dappy.test_runner = 'pytest'

local opts = { silent = true, noremap = true }

vim.keymap.set('n', '<F5>', require('dap').continue, opts)
vim.keymap.set('n', '<leader>b', require('dap').toggle_breakpoint, opts)
