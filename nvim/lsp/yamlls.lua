---@type vim.lsp.Config
return {
  cmd = { 'bunx', 'yaml-language-server', '--stdio' },
  root_markers = {
    '.git',
    '.yamllint',
    'yaml-language-server.yaml',
  },
  filetypes = {
    'yaml',
    'yaml.docker-compose',
  },
}
