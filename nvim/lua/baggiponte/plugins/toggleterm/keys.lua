return {
  {
    '<leader>lg',
    function()
      vim.cmd([[ToggleLazyGit]])
    end,
    desc = 'ToggleTerm: toggle [l]azy[g]it',
    silent = true,
    noremap = true,
  },
  {
    '<leader>ip',
    function()
      vim.cmd([[ToggleIPython]])
    end,
    desc = 'ToggleTerm: toggle [i][p]ython',
  },
  {
    '<leader>tt',
    function()
      vim.cmd([[ToggleTerm direction=vertical size=50 dir='%:p:h']])
    end,
    desc = 'ToggleTerm: [t]oggle [t]erminal',
    silent = true,
    noremap = true,
  },
  {
    '<leader>te',
    function()
      vim.cmd([[ToggleTermSendCurrentLine]])
    end,
    desc = '[t]oggleTerm: [e]xecute current line',
  },
  {
    '<leader>te',
    function()
      vim.cmd([[ToggleTermSendVisualSelection]])
    end,
    mode = 'v',
    desc = '[t]oggleTerm: [e]xecute current visual selection',
  },
  {
    '<leader>tE',
    function()
      vim.cmd([[ToggleTermSendVisualLines]])
    end,
    mode = 'v',
    desc = '[t]oggleTerm: [E]xecute current visual lines',
  },
  -- {
  --   '<leader>tr',
  --   function()
  --     vim.cmd([[ToggleREPLAuto]])
  --   end,
  --   desc = '[t]oggle [r]epl according to the filetype',
  --   silent = true,
  --   noremap = true,
  -- },
}
