---@type vim.lsp.Config
return {
  cmd = { 'uvx', '--from=ty', '--', 'ty', 'server' },
  filetypes = { 'python' },
  root_markers = {
    '.git',
    'pyproject.toml',
    'ty.toml',
  },
}
