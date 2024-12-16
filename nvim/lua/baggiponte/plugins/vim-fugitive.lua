return {
  'tpope/vim-fugitive',
  cmd = 'Git',
  keys = {
    {
      '<leader>G',
      '<cmd>Git<CR>',
      mode = { 'n', 'v' },
      desc = 'Fugitive: toggle git status window',
    },
    {
      '<leader>gc',
      '<cmd>Git commit<CR>',
      mode = { 'n', 'v' },
      desc = 'Fugitive: git commit',
    },
  },
}
