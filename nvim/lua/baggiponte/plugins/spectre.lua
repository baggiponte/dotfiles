local safe_require = require('baggiponte.utils').safe_require

return {
  'nvim-pack/nvim-spectre',
  keys = {
    {
      '<leader>S',
      function()
        safe_require('spectre').open()
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
