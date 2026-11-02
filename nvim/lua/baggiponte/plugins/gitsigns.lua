local keys = {
  {
    '<leader>hs',
    '<cmd>Gitsigns stage_hunk<CR>',
    mode = { 'n', 'v' },
    desc = 'Gitsigns: stage hunk',
  },
  {
    '<leader>hS',
    '<cmd>Gitsigns stage_buffer<CR>',
    mode = { 'n', 'v' },
    desc = 'Gitsigns: stage buffer',
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

local defer = require('baggiponte.defer')

-- gitsigns' plugin/ file already calls setup() itself and attaches to buffers
-- lazily, so configuring it eagerly costs nothing extra.
require('gitsigns').setup({
  current_line_blame = false,
})
defer.on_keys(keys)
