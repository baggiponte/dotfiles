---@type vim.lsp.Config
return {
  cmd = { 'uvx', '--from=rumdl', '--', 'rumdl', 'server' },
  filetypes = { 'markdown' },
}
