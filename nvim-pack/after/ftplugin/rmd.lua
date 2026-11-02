-- Reuse the Markdown settings for R Markdown: re-label the buffer, then
-- re-run the Markdown ftplugin explicitly (a FileType change inside a
-- FileType autocmd doesn't nest, so it wouldn't run on its own).
vim.bo.filetype = 'markdown'
vim.cmd('runtime! ftplugin/markdown.lua')
