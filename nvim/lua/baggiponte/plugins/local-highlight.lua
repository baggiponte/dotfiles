return {
  'tzachar/local-highlight.nvim',
  event = 'VeryLazy',
  config = function()
    require('local-highlight').setup({
      file_types = { 'python', 'lua' },
    })
  end,
}
