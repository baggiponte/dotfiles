---@type vim.lsp.Config
return {
  cmd = { 'uvx', 'sqruff', 'lsp' },
  filetypes = { 'sql' },
  root_markers = {
    '.git',
    '.sqruff',
  },
}
