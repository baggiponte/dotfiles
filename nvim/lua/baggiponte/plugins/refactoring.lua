return {
  'ThePrimeagen/refactoring.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  keys = {
    {
      '<leader>rr',
      require('refactoring').select_refactor,
      desc = 'Refactor: select refactor',
    },
  },
  cmd = { 'Refactor' },
  opts = {},
}
