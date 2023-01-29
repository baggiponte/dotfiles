return {
  'lewis6991/gitsigns.nvim',
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
}
