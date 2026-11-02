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

local defer = require('baggiponte.defer')

defer.on_keys(
  keys,
  defer.loader({ 'namu.nvim' }, function()
    require('namu').setup({})
  end)
)
