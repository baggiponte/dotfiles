return {
  {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    event = 'VeryLazy',
    opts = {},
  },
  {
    'folke/trouble.nvim',
    enabled = false,
    cmd = { 'Trouble', 'TroubleClose', 'TroubleToggle' },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
}
