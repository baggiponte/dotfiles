local aerial = { 'aerial', colored = true }

return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  dependencies = {
    { 'stevearc/aerial.nvim', cmd = 'AerialToggle', config = true },
  },
  opts = {
    options = { theme = 'auto' },
    sections = {
      lualine_c = { { 'filename' }, aerial },
    },
  },
}
