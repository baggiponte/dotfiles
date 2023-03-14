return {
  {
    'tpope/vim-fugitive',
    event = 'VeryLazy',
    keys = {
      {
        '<leader>G',
        '<cmd>Git<CR>',
        mode = { 'n', 'v' },
        desc = 'Fugitive: toggle [g]it status window',
      },
      {
        '<leader>gc',
        '<cmd>Git commit<CR>',
        mode = { 'n', 'v' },
        desc = 'Fugitive: [g]it [c]ommit',
      },
    },
  },
  {
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    dependencies = 'nvim-lua/plenary.nvim',
    keys = {
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
    },
    config = function()
      require('gitsigns').setup({
        signs = {
          add = { hl = 'GitGutterAdd', text = '|' },
          change = { hl = 'GitGutterChange', text = '|' },
          delete = { hl = 'GitGutterDelete', text = '_' },
          topdelete = { hl = 'GitGutterDelete', text = '‾' },
          changedelete = { hl = 'GitGutterChange', text = '~' },
        },
      })
    end,
  },
}
