local sources_dap = {
  'python',
}

local sources_lsp = {
  'jsonls',
  'pyright',
  'sumneko_lua',
  'yamlls',
}

local sources_null_ls = {
  'actionlint',
  'black',
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

local borders = require('baggiponte.utils.borders')

require('mason').setup({ ui = { border = borders } })

require('mason-nvim-dap').setup({
  ensure_installed = sources_dap,
})

require('mason-lspconfig').setup({
  ensure_installed = sources_lsp,
})

require('mason-null-ls').setup({
  ensure_installed = sources_null_ls,
})
