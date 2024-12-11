return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  cmd = 'Neotree',
  keys = {
    {
      '<leader>N',
      '<cmd>Neotree toggle<CR>',
      mode = { 'n', 'v' },
      desc = 'Toggle NeoTree',
    },
  },
}
