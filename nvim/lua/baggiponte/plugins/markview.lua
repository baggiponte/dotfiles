local keys = {
  {
    '<leader>mm',
    '<cmd>Markview<cr>',
    desc = 'Markview: toggle markview',
  },
}
return {
  'OXY2DEV/markview.nvim',
  ft = { 'markdown', 'rmd', 'quarto', 'mdx', 'pandoc' },
  keys = keys,
  opts = {
    preview = {
      enable = false,
    },
  },
}
