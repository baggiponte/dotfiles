return {
  'echasnovski/mini.comment',
  version = '*',
  event = 'BufEnter',
  config = function()
    require('mini.comment').setup({})
  end,
}
