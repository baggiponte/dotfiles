---@type vim.lsp.Config
return {
  cmd = { 'uvx', 'basedpyright-langserver', '--stdio' },
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
        inlayHints = {
          variableTypes = true,
          callArgumentNames = true,
          functionReturnTypes = true,
          genericTypes = true,
        },
      },
    },
  },
}
