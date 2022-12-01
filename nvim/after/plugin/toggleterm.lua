local cmd = vim.api.nvim_create_user_command

local Terminal = require('toggleterm.terminal').Terminal

cmd('ToggleTermREPL', function(opts)
  if vim.fn.executable(opts.args) ~= 1 then
    vim.notify(opts.args .. 'not found on $PATH', vim.log.levels.ERROR)
  end

  local repl = Terminal:new({ cmd = opts.args, hidden = true, direction = 'vertical' })

  repl:toggle(60)
end, { nargs = 1 })

local lazygit = Terminal:new({ cmd = 'lazygit', hidden = true, direction = 'float' })

local opts = { silent = true, noremap = true }

vim.keymap.set('n', '<leader>tt', function()
  vim.cmd([[ToggleTerm direction=vertical size=50 dir='%:p:h']])
end, opts)

vim.keymap.set('n', '<leader>tr', function()
  vim.cmd([[ToggleTermREPL radian]])
end)

vim.keymap.set('n', '<leader>tj', function()
  vim.cmd([[ToggleTermREPL julia]])
end)

vim.keymap.set('n', '<leader>tp', function()
  vim.cmd([[ToggleTermREPL ipython]])
end)

vim.keymap.set('n', '<leader>lg', function()
  lazygit:toggle()
end, { noremap = true, silent = true })

-- [[ key mappings ]]
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
