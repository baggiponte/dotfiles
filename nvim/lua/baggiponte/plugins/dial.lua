local import = require('baggiponte.utils').import

local keys = {
  {
    '<C-a>',
    function()
      import('dial.map').manipulate('increment', 'normal')
    end,
    desc = 'Increment number',
  },
  {
    '<C-x>',
    function()
      import('dial.map').manipulate('decrement', 'normal')
    end,
    desc = 'Decrement number',
  },
  {
    '<C-a>',
    mode = { 'v' },
    function()
      import('dial.map').manipulate('increment', 'visual')
    end,
    desc = 'Increment number',
  },
  {
    '<C-x>',
    mode = { 'v' },
    function()
      import('dial.map').manipulate('decrement', 'visual')
    end,
    desc = 'Decrement number',
  },
}

return {
  'monaqa/dial.nvim',
  lazy = true,
  keys = keys,
}
