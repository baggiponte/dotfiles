return {
  'mhinz/vim-sayonara',
  cmd = 'Sayonara',
  keys = {
    {
      'q',
      '<cmd>Sayonara<CR>',
      mode = { 'n', 'v' },
      desc = '[q]uit current buffer with Sayonara',
    },
    {
      'Q',
      '<cmd>Sayonara!<CR>',
      mode = { 'n', 'v' },
      desc = 'Force [Q]uit current buffer with Sayonara',
    },
  },
}
