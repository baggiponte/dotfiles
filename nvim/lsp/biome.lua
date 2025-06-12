---@type vim.lsp.Config
return {
  cmd = { 'bunx', 'biome', 'lsp-proxy' },
  root_markers = {
    'biome.json',
    'biome.jsonc',
    '.git',
  },
  filetypes = {
    'javascript',
    'typescript',
    'json',
    'jsonc',
  },
}
