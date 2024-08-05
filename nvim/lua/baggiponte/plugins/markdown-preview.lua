return {
  'iamcco/markdown-preview.nvim',
  cmd = { 'MarkdownPreviewToggle' },
  ft = 'markdown',
  build = function()
    vim.fn['mkdp#util#install']()
  end,
  config = function()
    vim.g.mkdp_theme = 'light'
  end,
}
