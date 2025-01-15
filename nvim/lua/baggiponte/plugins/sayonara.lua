return {
  'mhinz/vim-sayonara',
  cmd = 'Sayonara',
  keys = {
    {
      'q',
      '<cmd>Sayonara<CR>',
      mode = { 'n', 'v' },
      desc = 'Sayonara: quit current buffer',
    },
    {
      'Q',
      '<cmd>Sayonara!<CR>',
      mode = { 'n', 'v' },
      desc = 'Sayonara: force quit current buffer',
    },
  },
}
