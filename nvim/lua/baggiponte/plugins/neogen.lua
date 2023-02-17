return {
  'danymat/neogen',
  dependencies = 'nvim-treesitter/nvim-treesitter',
  keys = {
    {
      '<Leader>nf',
      ":lua require('neogen').generate()<CR>",
      silent = true,
      noremap = true,
    },
  },
  opts = {
    languages = {
      python = {
        template = {
          annotation_convention = 'google_docstrings',
        },
      },
    },
  },
}
