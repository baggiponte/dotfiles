---@type vim.lsp.Config
return {
  cmd = { 'uvx', '--from=ty', '--', 'ty', 'server' },
  filetypes = { 'python' },
  root_markers = {
    'pyproject.toml',
    'ty.toml',
    'uv.lock',
    '.git',
  },
}
