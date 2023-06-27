local needs = function(executable)
  if vim.fn.executable(executable) ~= 1 then
    vim.notify(executable .. ' not found on $PATH', vim.log.levels.ERROR)
  end
end

local create_terminal = function(opts)
  local Terminal = require('toggleterm.terminal').Terminal
  return Terminal:new({ cmd = opts.command, hidden = opts.hidden, direction = opts.direction })
end

local commands = {
  {
    name = 'ToggleLazyGit',
    callable = function()
      needs('lazygit')

      local terminal = create_terminal({ command = 'lazygit', direction = 'float', hidden = true })

      local size = math.floor(vim.o.columns * 0.4)
      terminal:toggle(size)
    end,
    nargs = 0,
  },
}

local keys = {
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
    '<leader>tt',
    function()
      vim.cmd([[ToggleTerm direction=vertical size=50 dir='%:p:h']])
    end,
    desc = 'ToggleTerm: [t]oggle [t]erminal',
    silent = true,
    noremap = true,
  },
}

return {
  'akinsho/toggleterm.nvim',
  cmd = {
    'ToggleTerm',
    'ToggleLazyGit',
  },
  version = '*',
  enable = false,
  keys = keys,
  config = function()
    for _, command in ipairs(commands) do
      vim.api.nvim_create_user_command(command.name, command.callable, { nargs = command.nargs })
    end

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
}
