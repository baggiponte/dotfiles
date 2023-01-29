return {
  'mhinz/vim-spectre',
  keys = {
    {
      '<leader>S',
      require('spectre').open,
      desc = 'Toggle [S]pecte.nvim',
    },
  },
  config = true,
}
