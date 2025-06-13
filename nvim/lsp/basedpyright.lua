---@type vim.lsp.Config
return {
  cmd = { 'uvx', '--from=basedpyright', '--', 'basedpyright-langserver', '--stdio' },
  root_markers = {
    'uv.lock',
    '.venv',
    '.git',
    'pyproject.toml',
  },
  filetypes = { 'python' },
  settings = {
    basedpyright = {
      verboseOutput = true,
      disableOrganizeImports = true,
      analysis = {
        diagnosticMode = 'workspace',
        typeCheckingMode = 'standard',
        inlayHints = {
          variableTypes = true,
          -- callArgumentNames = true,
          functionReturnTypes = true,
          genericTypes = true,
        },
      },
    },
  },
}
