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
  windows = {
    terminal = {
      position = 'right',
      size = 50,
    },
  },
  -- REPL and watches first: they're what a debugging session starts with.
  winbar = {
    show = true,
    sections = {
      'repl',
      'watches',
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

  dap_view.setup(dap_views_opt)

  dap_python.setup('uv')
  dap_python.test_runner = 'pytest'

  dap.listeners.after.event_initialized['baggiponte'] = function()
    dap_view.open()
  end
end)

defer.on_keys(keys, setup)
-- nvim-dap's plugin/ defines the real commands, replacing these stubs.
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
