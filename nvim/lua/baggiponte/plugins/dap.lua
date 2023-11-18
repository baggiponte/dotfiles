local import = require('baggiponte.utils').import

return {
  {
    'mfussenegger/nvim-dap-python',
    ft = 'python',
    config = function()
      local dappy = import('dap-python')
      dappy.setup(vim.fn.stdpath('data') .. '/mason/packages/debugpy/venv/bin/python')
      dappy.test_runner = 'pytest'
    end,
  },
  {
    'mfussenegger/nvim-dap',
    dependencies = {
    'rcarriga/nvim-dap-ui',
    'theHamsta/nvim-dap-virtual-text',
    },
    keys = {
      {
        '<F5>',
        function()
          import('dap').continue()
        end,
        desc = 'Start debugger session',
        silent = true,
        noremap = true,
      },
      {
        '<leader>b',
        function()
          import('dap').toggle_breakpoint()
        end,
        desc = 'Toggle debugger [b]reakpoint',
        silent = true,
        noremap = true,
      },
      config = function()
        local dap = import('dap')
        local dapui = import('dapui')

        dap.listeners.after.event_initialized['dapui_config'] = function()
          dapui.open({})
        end

        dap.listeners.before.event_terminated['dapui_config'] = function()
          dapui.close({})
        end

        dap.listeners.before.event_exited['dapui_config'] = function()
          dapui.close({})
        end
      end,
    },
  },
}
