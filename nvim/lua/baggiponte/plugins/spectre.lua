return {
  'nvim-pack/nvim-spectre',
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
