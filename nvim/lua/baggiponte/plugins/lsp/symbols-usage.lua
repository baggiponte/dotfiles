return {
  'Wansmer/symbol-usage.nvim',
  event = 'LspAttach',
  opts = {
    disable = {
      lsp = { 'dockerls', 'docker-compose-language-service', 'yamlls', 'jsonls' },
    },
  },
}
