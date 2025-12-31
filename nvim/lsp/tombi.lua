---@type vim.lsp.Config
return {
  cmd = { 'uvx', 'tombi', 'lsp' },
  filetypes = { 'toml' },
  root_markers = {
    'tombi.toml',
    'pyproject.toml',
    '.git',
  },
}
