local group = vim.api.nvim_create_augroup('baggiponte', { clear = true })

vim.api.nvim_create_autocmd('TextYankPost', {
  group = group,
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
  group = group,
  desc = 'Strip trailing whitespace',
  command = [[%s/\s\+$//e]],
})

-- Shell scripts use 4 spaces; everything else keeps the global 2 or what its
-- runtime ftplugin sets (4 for Python). The shell ftplugins set no indent, so
-- this doesn't need to run after them.
vim.api.nvim_create_autocmd('FileType', {
  group = group,
  pattern = { 'sh', 'bash', 'zsh' },
  callback = function()
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
  end,
})
