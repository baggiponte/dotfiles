return {
  'Wansmer/symbol-usage.nvim',
  enabled = false,
  event = 'LspAttach',
  opts = {
    disable = {
      lsp = { 'dockerls', 'docker-compose-language-service', 'yamlls', 'jsonls' },
    },
  },
}
