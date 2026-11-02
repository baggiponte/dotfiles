local defer = require('baggiponte.defer')

local keys = {
  { '<leader>dm', defer.call('neotest', 'run.run'), desc = 'neotest: test method' },
  { '<leader>dM', defer.call('neotest', 'run.run', { strategy = 'dap' }), desc = 'neotest: test method with debugger' },
  { '<leader>dS', defer.call('neotest', 'summary.toggle'), desc = 'neotest: debug summary' },
}

defer.on_keys(
  keys,
  defer.loader({ 'nvim-nio', 'plenary.nvim', 'neotest', 'neotest-python' }, function()
    -- the dap strategy needs nvim-dap
    require('baggiponte.plugins.dap').load()
    require('neotest').setup({
      adapters = {
        require('neotest-python')({
          dap = {
            justMyCode = false,
            console = 'integratedTerminal',
          },
          runner = 'pytest',
        }),
      },
    })
  end)
)
