---@type vim.lsp.Config
return {
  cmd = { 'docker-langserver', '--stdio' },
  root_markers = {
    '.git',
    'Dockerfile',
  },
  filetypes = { 'dockerfile' },
}
