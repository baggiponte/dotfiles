local keys = {
  {
    '<leader>tt',
    function()
      vim.cmd([[ToggleTerm direction=vertical size=50 dir='%:p:h']])
    end,
    desc = '[t]oggle [t]erminal',
    silent = true,
    noremap = true,
  },
  {
    '<leader>tr',
    function()
      vim.cmd([[ToggleREPLAuto]])
    end,
    desc = '[t]oggle [r]epl according to the filetype',
    silent = true,
    noremap = true,
  },
  {
    '<leader>lg',
    function()
      vim.cmd([[ToggleLazyGit]])
    end,
    desc = 'Toggle [l]azy[g]it',
    silent = true,
    noremap = true,
  },
  {
    '<leader>te',
    function()
      vim.cmd([[ToggleTermSendCurrentLine]])
    end,
    desc = '[t]oggleTerm [e]xecute current line',
  },
  {
    '<leader>te',
    function()
      vim.cmd([[ToggleTermSendVisualSelection]])
    end,
    mode = 'v',
    desc = '[t]oggleTerm [e]xecute current visual selection',
  },
  {
    '<leader>tE',
    function()
      vim.cmd([[ToggleTermSendVisualLines]])
    end,
    mode = 'v',
    desc = '[t]oggleTerm [E]xecute current visual lines',
  },
}

return {
  'akinsho/toggleterm.nvim',
  cmd = { 'ToggleTerm', 'ToggleLazyGit', 'ToggleREPL', 'ToggleREPLAuto' },
  version = '*',
  config = function()
    local cmd = vim.api.nvim_create_user_command

    local Terminal = require('toggleterm.terminal').Terminal

    cmd('ToggleREPL', function(opts)
      if vim.fn.executable(opts.args) ~= 1 then
        vim.notify(opts.args .. 'not found on $PATH', vim.log.levels.ERROR)
      end

      local repl = Terminal:new({ cmd = opts.args, hidden = true, direction = 'vertical' })

      repl:toggle(60)
    end, { nargs = 1 })

    cmd('ToggleLazyGit', function()
      if vim.fn.executable('lazygit') ~= 1 then
        vim.notify('lazygit not found on $PATH', vim.log.levels.ERROR)
      end
      local lazygit = Terminal:new({ cmd = 'lazygit', hidden = true, direction = 'float' })
      lazygit:toggle()
    end, {})

    cmd('ToggleREPLAuto', function()
      local filetypes = {
        julia = 'julia',
        lua = 'lua',
        python = 'ipython',
        quarto = 'radian',
        r = 'radian',
        rmd = 'radian',
      }

      local buffer_ft = vim.bo.filetype
      local repl = filetypes[buffer_ft]

      if repl == nil then
        vim.notify('No REPL associated with current filetype', vim.log.levels.ERROR)
      else
        vim.cmd('ToggleREPL ' .. filetypes[buffer_ft])
      end
    end, {})

    -- [[ terminal key mappings ]]
    function _G.set_terminal_keymaps()
      local termopts = { buffer = 0 }
      vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], termopts)
      vim.keymap.set('t', '<C-h>', [[<esc><Cmd>wincmd h<CR>]], termopts)
      vim.keymap.set('t', '<C-j>', [[<esc><Cmd>wincmd j<CR>]], termopts)
      vim.keymap.set('t', '<C-k>', [[<esc><Cmd>wincmd k<CR>]], termopts)
      vim.keymap.set('t', '<C-l>', [[<esc><Cmd>wincmd l<CR>]], termopts)
    end

    -- if you only want these mappings for toggle term use term://*toggleterm#* instead
    vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

    require('toggleterm').setup({
      direction = 'float',
      float_opts = {
        border = 'curved',
      },
    })
  end,
  keys = keys,
}
