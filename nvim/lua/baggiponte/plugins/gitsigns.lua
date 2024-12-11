local keys = {
  {
    '<leader>hs',
    '<cmd>Gitsigns stage_hunk<CR>',
    mode = { 'n', 'v' },
  },
  {
    '<leader>hr',
    '<cmd>Gitsigns reset_hunk<CR>',
    mode = { 'n', 'v' },
  },
  {
    '<leader>hp',
    '<cmd>Gitsigns preview_hunk<CR>',
  },
  {
    ']h',
    function()
      local gs = require('gitsigns')

      if vim.wo.diff then
        return ']h'
      end

      vim.schedule(function()
        gs.next_hunk()
      end)

      return '<Ignore>'
    end,
    expr = true,
  },
  {
    '[h',
    function()
      local gs = require('gitsigns')

      if vim.wo.diff then
        return '[h'
      end

      vim.schedule(function()
        gs.prev_hunk()
      end)

      return '<Ignore>'
    end,
    expr = true,
  },
}

return {
  'lewis6991/gitsigns.nvim',
  event = 'VeryLazy',
  dependencies = 'nvim-lua/plenary.nvim',
  keys = keys,
  opts = {
    current_line_blame = false,
    preview_config = { border = 'round' },
  },
}
