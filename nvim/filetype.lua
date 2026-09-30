-- Filetype detection, replacing the old ftdetect/*.vim autocmds.
-- Sourced automatically by Neovim before ftdetect/ (which we no longer use).
-- See :h vim.filetype.add()
vim.filetype.add({
  filename = {
    Brewfile = 'ruby',
    ['.envrc'] = 'bash',
    ['.env'] = 'bash',
    ['.env.*'] = 'bash',
    Jenkinsfile = 'groovy',
    jenkinsfile = 'groovy',
  },
  extension = {
    jenkinsfile = 'groovy',
    mdx = 'markdown',
  },
})
