local keys = {
  {
    'gsb',
    '<cmd>Namu symbols<cr>',
    desc = 'Namu: display LSP buffer symbols',
  },
  {
    'gsw',
    '<cmd>Namu workspace<cr>',
    desc = 'Namu: display LSP workspace symbols',
  },
}

return {
  'bassamsdata/namu.nvim',
  opts = {},
  keys = keys,
}
