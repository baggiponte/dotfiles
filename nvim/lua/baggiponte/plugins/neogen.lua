return {
  'danymat/neogen',
  dependencies = 'nvim-treesitter/nvim-treesitter',
  cmd = { 'Neogen' },
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
