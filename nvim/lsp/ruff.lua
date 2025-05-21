---@type vim.lsp.Config
return {
  cmd = { 'ruff', 'server' },
  root_markers = {
    '.git',
    'pyproject.toml',
    'ruff.toml',
  },
  filetypes = { 'python' },
  capabilities = {
    hoverProvider = false,
  },
}
