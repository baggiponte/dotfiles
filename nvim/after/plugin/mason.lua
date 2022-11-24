local sources_dap = {
  'python',
}

local sources_lsp = {
  'bashls',
  'dockerls',
  'jsonls',
  'marksman',
  'pyright',
  'sqlls',
  'sumneko_lua',
  'yamlls',
}

local sources_null_ls = {
  'actionlint',
  'black',
  'flake8',
  'isort',
  'jq',
  'ruff',
  'selene',
  'shellcheck',
  'shfmt',
  'stylua',
  'yamlfmt',
  'yamllint',
}

require('mason').setup({})

require('mason-nvim-dap').setup({
  ensure_installed = sources_dap,
})

require('mason-lspconfig').setup({
  ensure_installed = sources_lsp,
})

require('mason-null-ls').setup({
  ensure_installed = sources_null_ls,
})
