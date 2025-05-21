---@type vim.lsp.Config
return {
  cmd = { 'uvx', '--from=sqruff', '--', 'sqruff', 'lsp' },
  filetypes = { 'sql' },
  root_markers = {
    '.git',
    '.sqruff',
  },
}
