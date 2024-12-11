local keys = {
  {
    '<leader>tp',
    function()
      vim.cmd([[REPLStart bpython]])
    end,
    desc = 'yarepl: [t]oggle [p]ython repl with bpython',
  },
  {
    '<leader>tf',
    function()
      vim.cmd([[REPLHideOrFocus]])
    end,
    desc = 'yarepl: [r]epl [f]ocus',
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
    '<leader>tx',
    function()
      vim.cmd([[REPLSendOperator]])
    end,
    desc = 'yarepl: [r]epl [s]end visual selection',
  },
}

return {
  'milanglacier/yarepl.nvim',
  cmd = 'REPLStart',
  config = function()
    local yarepl = require('yarepl')

    yarepl.setup({
      wincmd = string.format('vertical %d split', math.floor(vim.o.columns * 0.4)),
      metas = {
        bpython = {
          cmd = function()
            if vim.fn.executable('bpython') == 1 then
              return { 'bpython' }
            else
              return { 'uv', 'run', 'bpython' }
            end
          end,
          formatter = yarepl.formatter.trim_empty_lines,
        },
      },
    })
  end,
  keys = keys,
}
