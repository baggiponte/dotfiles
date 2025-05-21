---@type vim.lsp.Config
return {
  cmd = { 'basedpyright' },
  root_markers = {
    '.git',
    'pyproject.toml',
  },
  filetypes = { 'python' },
  settings = {
    basedpyright = {
      disableOrganizeImports = true,
      analysis = {
        diagnosticMode = 'workspace',
        typeCheckingMode = 'standard',
      },
    },
  },
}
