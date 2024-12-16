local keys = {
  {
    '<leader>ds',
    function()
      require('dap').continue()
    end,
    desc = 'Start debugger session',
    silent = true,
    noremap = true,
  },
  {
    '<leader>dt',
    function()
      require('dapui').toggle()
    end,
    desc = 'debugger toggle',
  },
  {
    '<leader>b',
    function()
      require('dap').toggle_breakpoint()
    end,
    desc = 'Toggle debugger breakpoint',
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

      require('dap-python').resolve_python = function()
        ---@type string
        local venv_path = vim.fs.find({ '.venv' }, {
          upward = true,
          stop = vim.uv.os_homedir(),
          type = 'directory',
          limit = 1,
        })[1]

        return venv_path .. '/bin/python'
      end
    end,
  },
  {
    'mfussenegger/nvim-dap',
    keys = keys,
    dependencies = {
      { 'theHamsta/nvim-dap-virtual-text', opts = {} },
      {
        'rcarriga/nvim-dap-ui',
        dependencies = { 'nvim-neotest/nvim-nio' },
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
