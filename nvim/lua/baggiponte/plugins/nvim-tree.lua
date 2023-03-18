return {
  'nvim-tree/nvim-tree.lua',
  cmd = 'NvimTreeToggle',
  keys = {
    {
      '<Leader>N',
      '<cmd>NvimTreeToggle<CR>',
      mode = { 'n', 'v' },
    },
  },
  config = true,
}
