local safe_require = require('baggiponte.utils').safe_require

local keys = {
  {
    '<C-a>',
    function()
      safe_require('dial.map').manipulate('increment', 'normal')
    end,
    desc = 'Increment number',
  },
  {
    '<C-x>',
    function()
      safe_require('dial.map').manipulate('decrement', 'normal')
    end,
    desc = 'Decrement number',
  },
  {
    '<C-a>',
    mode = { 'v' },
    function()
      safe_require('dial.map').manipulate('increment', 'visual')
    end,
    desc = 'Increment number',
  },
  {
    '<C-x>',
    mode = { 'v' },
    function()
      safe_require('dial.map').manipulate('decrement', 'visual')
    end,
    desc = 'Decrement number',
  },
}

return {
  'monaqa/dial.nvim',
  lazy = true,
  keys = keys,
}
