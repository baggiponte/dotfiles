local sources = {
  'bashls',
  'dockerls',
  'jsonls',
  'marksman',
  'pyright',
  'sqlls',
  'sumneko_lua',
  'yamlls',
}

require('mason').setup({})

require('mason-lspconfig').setup({
  ensure_installed = sources,
})
