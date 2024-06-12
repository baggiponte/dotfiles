return {
  'stevearc/oil.nvim',
  cmd = 'Oil',
  opts = {
    show_hidden = true,
    is_always_hidden = function(name, bufnr)
      return name == '.git'
    end,
  },
  -- Optional dependencies
  dependencies = { 'nvim-tree/nvim-web-devicons' },
}
