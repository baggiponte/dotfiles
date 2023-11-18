local import = require('baggiponte.utils').import

local keys = {
  {
    '<leader>ip',
    function()
      vim.cmd([[REPLStart pdm]])
    end,
    desc = 'yarepl: [t]oggle [r]epl ipython with PDM',
  },
  {
    '<leader>tf',
    function()
      vim.cmd([[REPLFocus]])
    end,
    desc = 'yarepl: [r]epl [f]ocus',
  },
  {
    '<leader>th',
    function()
      vim.cmd([[REPLHide]])
    end,
    desc = 'yarepl: [r]epl [h]ide',
  },
  {
    '<leader>tc',
    function()
      vim.cmd([[REPLCleanup]])
    end,
    desc = 'yarepl: [r]epl [c]leanup',
  },
  {
    '<leader>tq',
    function()
      vim.cmd([[REPLClose]])
    end,
    desc = 'yarepl: {r}epl [q]uit',
  },
  {
    '<leader>te',
    function()
      vim.cmd([[REPLSendLine]])
    end,
    desc = 'yarepl: [r]epl [s]end line',
  },
  {
    '<leader>T',
    function()
      vim.cmd([[REPLSendVisual]])
    end,
    desc = 'yarepl: [r]epl [s]end visual selection',
    mode = 'v',
  },
  {
    '<leader>t',
    function()
      vim.cmd([[REPLSendMotion]])
    end,
    desc = 'yarepl: [r]epl [s]end visual selection',
  },
}

return {
  'milanglacier/yarepl.nvim',
  cmd = 'REPLStart',
  config = function()
    local yarepl = import('yarepl')

    yarepl.setup({
      wincmd = string.format('vertical %d split', math.floor(vim.o.columns * 0.4)),
      metas = {
        pdm = {
          cmd = { 'pdm', 'run', 'ipython' },
          formatter = yarepl.formatter.bracketed_pasting,
        },
      },
    })
  end,
  keys = keys,
}
