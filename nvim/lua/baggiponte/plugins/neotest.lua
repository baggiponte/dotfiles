local keys = {
  {
    '<leader>dm',
    function()
      require('neotest').run.run()
    end,
    desc = 'neotest: test method',
  },
  {
    '<leader>dM',
    function()
      require('neotest').run.run({ strategy = 'dap' })
    end,
    desc = 'neotest: test method with debugger',
  },
  {
    '<leader>dS',
    function()
      require('neotest').summary.toggle()
    end,
    desc = 'neotest: debug summary',
  },
}
local defer = require('baggiponte.defer')

defer.keys(
  keys,
  defer.loader({ 'nvim-nio', 'plenary.nvim', 'neotest', 'neotest-python' }, function()
    -- the dap strategy needs nvim-dap (a lazy.nvim dependency before)
    require('baggiponte.plugins.dap')()
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
