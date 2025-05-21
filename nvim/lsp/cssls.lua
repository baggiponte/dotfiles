---@type vim.lsp.Config
return {
  cmd = { 'css-languageserver', '--stdio' },
  root_markers = { '.git' },
  filetypes = {
    'css',
    'scss',
    'less',
  },
}
