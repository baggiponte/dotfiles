return {
  {
    'folke/todo-comments.nvim',
    cmd = { 'TodoTrouble', 'TodoTelescope', 'TodoQuickFix', 'TodoLocList' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {},
  },
  {
    'folke/trouble.nvim',
    cmd = { 'Trouble' },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {},
  },
}
