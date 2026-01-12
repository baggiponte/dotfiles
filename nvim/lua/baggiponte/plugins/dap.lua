local keys = {
  -- Session Control
  {
    '<leader>ds',
    function()
      require('dap').continue()
    end,
    desc = 'DAP: Start/Continue',
  },
  {
    '<leader>dr',
    function()
      require('dap').restart()
    end,
    desc = 'DAP: Restart Session',
  },
  {
    '<leader>dq',
    function()
      require('dap').terminate()
      require('dap-view').close()
    end,
    desc = 'DAP: Terminate Session',
  },

  -- Stepping
  {
    '<leader>dn',
    function()
      require('dap').step_over()
    end,
    desc = 'DAP: Step Over (Next)',
  },
  {
    '<leader>di',
    function()
      require('dap').step_into()
    end,
    desc = 'DAP: Step Into',
  },
  {
    '<leader>do',
    function()
      require('dap').step_out()
    end,
    desc = 'DAP: Step Out',
  },

  -- Breakpoints
  {
    '<leader>db',
    function()
      require('dap').toggle_breakpoint()
    end,
    desc = 'DAP: Toggle Breakpoint',
  },

  -- UI & Inspection
  {
    '<leader>dv',
    function()
      require('dap-view').toggle()
    end,
    desc = 'DAP: Toggle View',
  },
  {
    '<leader>dk',
    function()
      require('dap.ui.widgets').hover()
    end,
    desc = 'DAP: Hover Variables',
  },
}

local dap_views_opt = {
  -- Moves the main debug pane (terminal/repl) to the right side
  windows = {
    terminal = {
      position = 'right', -- Swaps from default 'left'
      size = 50, -- Adjust this percentage as needed
    },
  },
  -- Reorders the tabs in the winbar
  winbar = {
    show = true,
    sections = {
      'repl', -- REPL is now first
      'watches', -- Watches is now second
      'scopes',
      'exceptions',
      'breakpoints',
      'threads',
    },
    default_section = 'repl',
    controls = {
      enabled = true,
    },
  },
}

return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'igorlfs/nvim-dap-view',
    'mfussenegger/nvim-dap-python',
    'theHamsta/nvim-dap-virtual-text',
  },
  keys = keys,
  ft = { 'python' },
  config = function()
    local dap = require('dap')
    local dap_view = require('dap-view')
    local dap_python = require('dap-python')

    -- 1. Setup the UI
    dap_view.setup(dap_views_opt)

    -- 2. Setup Python with uv
    dap_python.setup('uv')
    dap_python.test_runner = 'pytest'

    -- 3. (Optional) Auto-open/close the view
    -- Note: dap-view users often prefer manual toggling,
    -- but you can automate it like this:
    dap.listeners.after.event_initialized['dapui_config'] = function()
      dap_view.open()
    end
  end,
}
