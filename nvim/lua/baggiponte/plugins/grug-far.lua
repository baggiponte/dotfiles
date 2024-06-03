return {
  'MagicDuck/grug-far.nvim',
  cmd = { 'GrugFar' },
  keys = {
    {
      '<leader>S',
      function()
        vim.cmd([[GrugFar]])
      end,
      desc = 'Toggle grug-far.nvim',
    },
  },
  opts = {},
}
