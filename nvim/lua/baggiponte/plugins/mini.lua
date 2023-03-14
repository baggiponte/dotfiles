return {
  {
    'echasnovski/mini.comment',
    version = false,
    keys = { 'gcc' },
    config = function()
      require('mini.comment').setup({})
    end,
  },
  {
    'echasnovski/mini.splitjoin',
    version = false,
    keys = { 'gss' },
    config = function()
      require('mini.splitjoin').setup({
        mappings = {
          toggle = 'gss',
        },
      })
    end,
  },
}
