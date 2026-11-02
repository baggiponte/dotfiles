local defer = require('baggiponte.defer')

local keys = {
  { '<leader>ds', defer.call('dap', 'continue'), desc = 'DAP: Start/Continue' },
  { '<leader>dr', defer.call('dap', 'restart'), desc = 'DAP: Restart Session' },
  {
    '<leader>dq',
    function()
      require('dap').terminate()
      require('dap-view').close()
    end,
    desc = 'DAP: Terminate Session',
  },
  { '<leader>dn', defer.call('dap', 'step_over'), desc = 'DAP: Step Over (Next)' },
  { '<leader>di', defer.call('dap', 'step_into'), desc = 'DAP: Step Into' },
  { '<leader>do', defer.call('dap', 'step_out'), desc = 'DAP: Step Out' },
  { '<leader>db', defer.call('dap', 'toggle_breakpoint'), desc = 'DAP: Toggle Breakpoint' },
  { '<leader>dv', defer.call('dap-view', 'toggle'), desc = 'DAP: Toggle View' },
  { '<leader>dk', defer.call('dap.ui.widgets', 'hover'), desc = 'DAP: Hover Variables' },
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

local setup = defer.loader({ 'nvim-dap', 'nvim-dap-view', 'nvim-dap-python', 'nvim-dap-virtual-text' }, function()
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
end)

defer.on_keys(keys, setup)
-- nvim-dap's plugin/ defines the real commands, replacing these stubs
defer.on_cmd({
  'DapClearBreakpoints',
  'DapContinue',
  'DapDisconnect',
  'DapEval',
  'DapNew',
  'DapPause',
  'DapRestartFrame',
  'DapSetLogLevel',
  'DapShowLog',
  'DapStepInto',
  'DapStepOut',
  'DapStepOver',
  'DapTerminate',
  'DapToggleBreakpoint',
  'DapToggleRepl',
  'DapViewClose',
  'DapViewHover',
  'DapViewJump',
  'DapViewNavigate',
  'DapViewOpen',
  'DapViewShow',
  'DapViewToggle',
  'DapViewVirtualTextDisable',
  'DapViewVirtualTextEnable',
  'DapViewVirtualTextToggle',
  'DapViewWatch',
}, setup)

return { load = setup }
