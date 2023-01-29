return {
  'echasnovski/mini.comment',
  version = '*',
  event = 'InsertEnter',
  config = function()
    require('mini.comment').setup()
  end,
}
