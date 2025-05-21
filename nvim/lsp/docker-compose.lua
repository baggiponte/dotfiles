---@type vim.lsp.Config
return {
  cmd = { 'docker-compose-language-service' },
  root_markers = {
    '.git',
    'docker-compose.yml',
    'docker-compose.yaml',
  },
  filetypes = { 'yaml.docker-compose' },
}
