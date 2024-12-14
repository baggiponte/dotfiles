local keys = {
  {
    '<leader>rr',
    function()
      require('refactoring').select_refactor()
    end,
    desc = 'Refactor: select refactor',
    mode = 'v',
  },
}

return {
  'ThePrimeagen/refactoring.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  keys = keys,
  cmd = { 'Refactor' },
  opts = {},
}
