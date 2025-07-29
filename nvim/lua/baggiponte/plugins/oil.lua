return {
  'stevearc/oil.nvim',
  cmd = 'Oil',
  keys = {
    {
      '<leader>o',
      '<CMD>Oil<CR>',
      desc = 'oil.nvim: toggle',
    },
  },
  opts = {
    view_options = {
      show_hidden = true,
      is_always_hidden = function(name, bufnr)
        local must_hide = { '.git' }

        for _, v in pairs(must_hide) do
          if name == v then
            return true
          end
        end
      end,
    },
  },
  -- Optional dependencies
  dependencies = { 'nvim-tree/nvim-web-devicons' },
}
