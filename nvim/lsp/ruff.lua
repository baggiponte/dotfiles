---@type vim.lsp.Config
return {
  cmd = { 'ruff-lsp' },
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
