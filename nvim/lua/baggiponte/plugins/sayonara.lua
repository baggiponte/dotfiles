-- Eager: its plugin/ only defines the command.
require('baggiponte.defer').on_keys({
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
})
