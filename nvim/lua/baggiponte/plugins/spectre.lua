return {
  'mhinz/vim-spectre',
  keys = {
    {
      '<leader>S',
      function()
        require('spectre').open()
      end,
      desc = 'Toggle [S]pecte.nvim',
    },
  },
  config = true,
}
