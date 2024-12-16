return {
  'mhinz/vim-sayonara',
  cmd = 'Sayonara',
  keys = {
    {
      'q',
      '<cmd>Sayonara<CR>',
      mode = { 'n', 'v' },
      desc = 'quit current buffer with Sayonara',
    },
    {
      'Q',
      '<cmd>Sayonara!<CR>',
      mode = { 'n', 'v' },
      desc = 'Force quit current buffer with Sayonara',
    },
  },
}
