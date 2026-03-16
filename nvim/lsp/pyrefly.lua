---@type vim.lsp.Config
return {
  cmd = { 'uvx', '--from=pyrefly', 'pyrefly', 'lsp' },
  root_markers = {
    'uv.lock',
    '.venv',
  },
  filetypes = { 'python' },
}
