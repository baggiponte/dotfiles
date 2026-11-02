local defer = require('baggiponte.defer')

defer.very_lazy(defer.loader({ 'dressing.nvim' }, function()
  require('dressing').setup({
    input = {
      enabled = false,
    },
  })
end))
