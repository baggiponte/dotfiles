local sources_dap = {
  'python',
}

local sources_lsp = {
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

local borders = { -- default borders are vim.g.border_chars
  { '╭', 'FloatBorder' },
  { '─', 'FloatBorder' },
  { '╮', 'FloatBorder' },
  { '│', 'FloatBorder' },
  { '╯', 'FloatBorder' },
  { '─', 'FloatBorder' },
  { '╰', 'FloatBorder' },
  { '│', 'FloatBorder' },
}

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
