---@type vim.lsp.Config
return {
  cmd = { 'biome', 'lsp-proxy' },
  root_markers = {
    '.git',
    'biome.json',
    'biome.jsonc',
  },
  filetypes = {
    'javascript',
    'typescript',
    'json',
    'jsonc',
  },
}
