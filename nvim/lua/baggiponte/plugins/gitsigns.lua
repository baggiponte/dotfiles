local keys = {
  {
    '<leader>hs',
    '<cmd>Gitsigns stage_hunk<CR>',
    mode = { 'n', 'v' },
    desc = 'Gitsigns: stage hunk',
  },
  {
    '<leader>hr',
    '<cmd>Gitsigns reset_hunk<CR>',
    mode = { 'n', 'v' },
    desc = 'Gitsigns: reset hunk',
  },
  {
    '<leader>hp',
    '<cmd>Gitsigns preview_hunk<CR>',
    mode = { 'n', 'v' },
    desc = 'Gitsigns: preview hunk',
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
    desc = 'Gitsigns: go to next hunk',
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
    desc = 'Gitsigns: go to previous hunk',
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
