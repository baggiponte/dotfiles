local import = require('baggiponte.utils').import

return {
  'nvim-pack/nvim-spectre',
  keys = {
    {
      '<leader>S',
      function()
        import('spectre').open()
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
