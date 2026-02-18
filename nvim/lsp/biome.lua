---@type vim.lsp.Config
return {
  cmd = { 'mise', 'x', 'biome@latest', '--', 'biome', 'lsp-proxy' },
  root_markers = {
    'biome.json',
    'biome.jsonc',
    '.git',
  },
  filetypes = {
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
    'css',
    'graphql',
    'html',
    'json',
    'jsonc',
  },
  settings = {
    html = {
      experimentalFullSupportEnabled = true,
    },
  },
}
