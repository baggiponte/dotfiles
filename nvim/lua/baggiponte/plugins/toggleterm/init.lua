local cmd = vim.api.nvim_create_user_command
local commands = require('baggiponte.plugins.toggleterm.commands')
local keys = require('baggiponte.plugins.toggleterm.keys')

return {
  'akinsho/toggleterm.nvim',
  cmd = {
    'ToggleTerm',
    'ToggleLazyGit',
    'ToggleREPL',
    'IPython',
    'ToggleTermSendCurrentLine',
    'ToggleTermSendVisualSelection',
    'ToggleTermSendVisualLines',
  },
  version = '*',
  enable = false,
  keys = keys,
  config = function()
    for _, command in ipairs(commands) do
      cmd(command.name, command.callable, { nargs = command.nargs })
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
