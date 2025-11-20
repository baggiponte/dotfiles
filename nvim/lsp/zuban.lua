---@type vim.lsp.Config
return {
  cmd = { 'uvx', 'zuban', 'server' },
  root_markers = {
    'uv.lock',
    '.venv',
  },
  filetypes = { 'python' },
}
