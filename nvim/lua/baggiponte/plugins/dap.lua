local import = require('baggiponte.utils').import

local keys = {
  {
    '<leader>ds',
    function()
      import('dap').continue()
    end,
    desc = 'Start [d]ebugger [s]ession',
    silent = true,
    noremap = true,
  },
  {
    '<leader>dt',
    function()
      import('dapui').toggle()
    end,
    desc = '[d]ebugger [t]oggle',
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
}

return {
  {
    'mfussenegger/nvim-dap-python',
    ft = 'python',
    dependencies = {
      'mfussenegger/nvim-dap',
    },
    config = function()
      local path = require('mason-registry').get_package('debugpy'):get_install_path()
      require('dap-python').setup(path .. '/venv/bin/python')
    end,
  },
  {
    'mfussenegger/nvim-dap',
    keys = keys,
    dependencies = {
      'rcarriga/nvim-dap-ui',
      opts = {
        icons = {
          expanded = '',
          collapsed = '',
          current_frame = '',
        },
        controls = {
          enabled = true,
          element = 'console',
          icons = {
            pause = '',
            play = '',
            step_into = '',
            step_over = '',
            step_out = '',
            step_back = '',
            run_last = '',
            terminate = '',
          },
        },
      },
    },
    config = function()
      local dap, dapui = require('dap'), require('dapui')

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
    end,
  },
}
