---@type vim.lsp.Config
return {
  cmd = { 'uvx', '--from=zizmor', '--', 'zizmor', '--lsp' },
  filetypes = { 'yaml' },
  root_markers = {
    '.workflows/',
    '.git',
  },
}
