local neogen_status, neogen = pcall(require, 'neogen')

if not neogen_status then
  return
end

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
