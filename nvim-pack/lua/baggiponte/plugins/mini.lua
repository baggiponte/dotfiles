-- the plugin sets its own `gss` mapping in setup(), which is cheap
require('mini.splitjoin').setup({
  mappings = {
    toggle = 'gss',
  },
})
