return {
  {
    'folke/todo-comments.nvim',
    cmd = { 'TodoTrouble', 'TodoTelescope', 'TodoQuickFix', 'TodoLocList' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {},
  },
  {
    'folke/trouble.nvim',
    enabled = false,
    cmd = { 'Trouble', 'TroubleClose', 'TroubleToggle' },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
}
