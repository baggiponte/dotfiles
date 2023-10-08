local safe_require = require('baggiponte.utils').safe_require

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
      ']h',
      function()
        local gs = safe_require('gitsigns')

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
        local gs = safe_require('gitsigns')

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
    signs = {
      add = { hl = 'GitGutterAdd', text = '|' },
      change = { hl = 'GitGutterChange', text = '|' },
      delete = { hl = 'GitGutterDelete', text = '_' },
      topdelete = { hl = 'GitGutterDelete', text = '‾' },
      changedelete = { hl = 'GitGutterChange', text = '~' },
    },
    current_line_blame = true,
    preview_config = { border = 'round' },
  }
}
