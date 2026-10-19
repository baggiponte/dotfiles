return {
  'christoomey/vim-tmux-navigator',
  enabled = vim.env.TMUX ~= nil and vim.env.TMUX ~= '',
  event = 'VeryLazy',
}
