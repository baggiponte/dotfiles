local defer = require('baggiponte.defer')

defer.on_event(
  'InsertEnter',
  defer.loader({ 'nvim-autopairs' }, function()
    require('nvim-autopairs').setup({})
  end)
)
