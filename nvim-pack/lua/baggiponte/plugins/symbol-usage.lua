local defer = require('baggiponte.defer')

defer.on_event(
  'LspAttach',
  defer.loader({ 'symbol-usage.nvim' }, function()
    require('symbol-usage').setup({})
  end)
)
