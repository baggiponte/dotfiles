return {
  {
    'echasnovski/mini.comment',
    version = false,
    event = 'VeryLazy',
    config = function()
      require('mini.comment').setup({})
    end,
  },
  {
    'echasnovski/mini.splitjoin',
    version = false,
    event = 'VeryLazy',
    config = function()
      require('mini.splitjoin').setup({
        mappings = {
          toggle = 'gss',
        },
      })
    end,
  },
}
