return {
  'stevearc/oil.nvim',
  cmd = 'Oil',
  keys = {
    { '<leader>o', '<CMD>Oil<CR>' },
  },
  opts = {
    show_hidden = true,
    is_always_hidden = function(name, bufnr)
      return name == '.git'
    end,
  },
  -- Optional dependencies
  dependencies = { 'nvim-tree/nvim-web-devicons' },
}
