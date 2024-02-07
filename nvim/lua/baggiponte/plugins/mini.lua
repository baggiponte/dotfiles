local import = require('baggiponte.utils').import

return {
  {
    'echasnovski/mini.comment',
    version = false,
    keys = {
      { 'gcc', mode = { 'n', 'v' } },
      { 'gc', mode = { 'n', 'v' } },
    },
    config = function()
      import('mini.comment').setup({})
    end,
  },
  {
    'echasnovski/mini.splitjoin',
    version = false,
    keys = { 'gss' },
    config = function()
      import('mini.splitjoin').setup({
        mappings = {
          toggle = 'gss',
        },
      })
    end,
  },
}
