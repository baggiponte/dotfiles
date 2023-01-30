return {
  'monaqa/dial.nvim',
  keys = {
    {
      '<C-a>',
      function()
        require('dial.map').inc_normal()
      end,
      noremap = true,
    },
    {
      '<C-x>',
      function()
        require('dial.map').dec_normal()
      end,
      noremap = true,
    },
    {
      '<C-a>',
      function()
        require('dial.map').inc_visual()
      end,
      mode = 'v',
      noremap = true,
    },
    {
      '<C-x>',
      function()
        require('dial.map').dec_visual()
      end,
      mode = 'v',
      noremap = true,
    },
    {
      'g<C-a>',
      function()
        require('dial.map').inc_gvisual()
      end,
      mode = 'v',
      noremap = true,
    },
    {
      'g<C-x>',
      function()
        require('dial.map').dec_gvisual()
      end,
      mode = 'v',
      noremap = true,
    },
  },
}
