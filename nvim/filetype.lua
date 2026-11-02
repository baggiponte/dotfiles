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
