---@type vim.lsp.Config
return {
  cmd = { 'bunx', '@microsoft/compose-language-service', '--stdio' },
  root_markers = {
    'docker-compose.yaml',
    'docker-compose.yml',
    'compose.yaml',
    'compose.yml',
  },
  filetypes = { 'yaml.docker-compose' },
}
