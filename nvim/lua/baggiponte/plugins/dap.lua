return {
  { 'rcarriga/nvim-dap-ui', name = 'dapui', config = true },
  { 'theHamsta/nvim-dap-virtual-text', dependencies = { 'nvim-treesitter/nvim-treesitter' }, config = true },
  {
    'mfussenegger/nvim-dap-python',
    config = function()
      local dappy = require('dap-python')
      dappy.setup(vim.fn.stdpath('data') .. '/mason/packages/debugpy/venv/bin/python')
      dappy.test_runner = 'pytest'
    end,
  },
  {
    'mfussenegger/nvim-dap',
    keys = {
      {
        '<F5>',
        function()
          require('dap').continue()
        end,
        desc = 'Start debugger session',
        silent = true,
        noremap = true,
      },
      {
        '<leader>b',
        function()
          require('dap').toggle_breakpoint()
        end,
        desc = 'Toggle debugger [b]reakpoint',
        silent = true,
        noremap = true,
      },
      config = function()
        local dap = require('dap')
        local dapui = require('dapui')

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
