---@type vim.lsp.Config
return {
  cmd = { 'uvx', 'ruff', 'server' },
  root_markers = {
    { 'ruff.toml', 'pyproject.toml' },
    'uv.lock',
    '.git',
  },
  filetypes = { 'python', 'toml', 'markdown' },
  capabilities = {
    hoverProvider = false,
  },
}
