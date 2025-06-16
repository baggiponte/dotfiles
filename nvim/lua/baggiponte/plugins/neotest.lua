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
return {
  'nvim-neotest/neotest',
  keys = keys,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'nvim-neotest/neotest-python',
  },
  config = function()
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
  end,
}
