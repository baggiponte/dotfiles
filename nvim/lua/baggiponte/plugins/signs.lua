return {
  { 'sindrets/diffview.nvim', cmd = 'DiffviewOpen', dependencies = 'nvim-lua/plenary.nvim' },
  {
    'lewis6991/gitsigns.nvim',
    event = 'BufReadPre',
    dependencies = 'nvim-lua/plenary.nvim',
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
