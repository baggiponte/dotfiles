---@type vim.lsp.Config
return {
  cmd = { 'uvx', 'pyrefly', 'lsp' },
  root_markers = {
    'uv.lock',
    '.venv',
  },
  filetypes = { 'python' },
}
