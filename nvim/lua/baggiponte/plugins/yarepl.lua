local keys = {
  {
    '<leader>tp',
    function()
      vim.cmd([[REPLStart bpython]])
    end,
    desc = 'yarepl: toggle python repl with bpython',
  },
  {
    '<leader>tf',
    function()
      vim.cmd([[REPLHideOrFocus]])
    end,
    desc = 'yarepl: REPL focus',
  },
  {
    '<leader>tq',
    function()
      vim.cmd([[REPLClose]])
    end,
    desc = 'yarepl: REPL quit',
  },
  {
    '<leader>te',
    function()
      vim.cmd([[REPLSendLine]])
    end,
    desc = 'yarepl: REPL send line',
  },
  {
    '<leader>T',
    function()
      vim.cmd([[REPLSendVisual]])
    end,
    desc = 'yarepl: REPL send visual selection',
    mode = 'v',
  },
  {
    '<leader>tx',
    function()
      vim.cmd([[REPLSendOperator]])
    end,
    desc = 'yarepl: repl send visual selection',
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
