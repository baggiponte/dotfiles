local neogen = require('neogen')

neogen.setup({
  languages = {
    python = {
      template = {
        annotation_convention = 'numpydoc',
      },
    },
  },
})

local opts = { noremap = true, silent = true }

vim.keymap.set('n', '<leader>nf', neogen.generate, opts)
