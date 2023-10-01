local keys = {
  {
    '<C-a>',
    function()
      require('dial.map').manipulate('increment', 'normal')
    end,
    desc = 'Increment number',
  },
  {
    '<C-x>',
    function()
      require('dial.map').manipulate('decrement', 'normal')
    end,
    desc = 'Decrement number',
  },
  {
    '<C-a>',
    mode = { 'v' },
    function()
      require('dial.map').manipulate('increment', 'visual')
    end,
    desc = 'Increment number',
  },
  {
    '<C-x>',
    mode = { 'v' },
    function()
      require('dial.map').manipulate('decrement', 'visual')
    end,
    desc = 'Decrement number',
  },
}

return {
  'monaqa/dial.nvim',
  keys = keys,
}
