local defer = require('baggiponte.defer')

-- nvim-surround maps these itself in setup(), so stub them until first use.
defer.on_keys(
  {
    { 'ys' },
    { 'yS' },
    { 'ds' },
    { 'cs' },
    { 'cS' },
    { 'S', mode = 'x' },
    { 'gS', mode = 'x' },
    { '<C-g>s', mode = 'i' },
    { '<C-g>S', mode = 'i' },
  },
  defer.loader({ 'nvim-surround' }, function()
    require('nvim-surround').setup({})
  end)
)
