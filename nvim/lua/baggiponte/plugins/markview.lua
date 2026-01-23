local keys = {
  {
    '<leader>mm',
    '<cmd>Markview<cr>',
    desc = 'Markview: toggle markview',
  },
}
return {
  'OXY2DEV/markview.nvim',
  lazy = false,
  keys = keys,
  opts = {
    preview = {
      enable = false,
    },
  },
}
