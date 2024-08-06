-- [[ Highlight on yank ]]
vim.api.nvim_exec2(
  [[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]],
  { output = false }
)

-- close some filetypes with <q>
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'TelescopePrompt' },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close!<cr>', { buffer = event.buf, silent = true })
  end,
})
