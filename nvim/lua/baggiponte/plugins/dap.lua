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
}

return {
  {
    'mfussenegger/nvim-dap',
    keys = keys,
  },
  {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap' },
    config = function()
      local dap = require('dap')
      local dapui = require('dapui')

      dapui.setup()

      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
      end

      dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close()
      end

      dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close()
      end
    end,
  },
  {
    'mfussenegger/nvim-dap-python',
    ft = 'python',
    dependencies = {
      'mfussenegger/nvim-dap',
      'mfussenegger/nvim-dap-ui',
    },
    config = function()
      local path = require('mason-registry').get_package('debugpy'):get_install_path()
      require('dap-python').setup(path .. '/venv/bin/python')
    end,
  },
}
