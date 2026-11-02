-- only load on lua files
local defer = require('baggiponte.defer')

defer.on_ft(
  'lua',
  defer.loader({ 'lazydev.nvim' }, function()
    require('lazydev').setup({
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    })
  end)
)
