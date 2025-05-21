---@type vim.lsp.Config
return {
  cmd = { 'bunx', 'docker-langserver', '--stdio' },
  root_markers = { 'Dockerfile' },
  filetypes = { 'dockerfile' },
}
