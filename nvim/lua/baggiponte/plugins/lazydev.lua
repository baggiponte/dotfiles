local defer = require('baggiponte.defer')

defer.on_ft(
  'lua',
  defer.loader({ 'lazydev.nvim' }, function()
    require('lazydev').setup({
      library = {
        -- luv types, only once a file mentions vim.uv
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    })
  end)
)
