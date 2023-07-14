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
  opts = {
    default = {
      find = {
        cmd = 'rg',
        options = { 'hidden' },
      },
    },
  },
}
