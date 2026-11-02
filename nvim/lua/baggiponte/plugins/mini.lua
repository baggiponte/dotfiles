-- Eager: setup() only creates the `gss` mapping.
require('mini.splitjoin').setup({
  mappings = {
    toggle = 'gss',
  },
})
