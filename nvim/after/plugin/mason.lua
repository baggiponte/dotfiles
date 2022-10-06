local servers = {
  'bashls',
  'dockerls',
  'jsonls',
  'marksman',
  'pyright',
  'sqlls',
  'sumneko_lua',
  'yamlls',
}

local linters = {
  'flake8',
  'mypy',
  'selene',
  'shellcheck',
  'sqlfluff',
  'yamllint',
}

local formatters = {
  'black',
  'isort',
  'jq',
  'shfmt',
  'stylua',
  'yamlfmt',
}

local sources = {}

for _, server in ipairs(servers) do
  table.insert(sources, server)
end

for _, linter in ipairs(linters) do
  table.insert(sources, linter)
end

for _, formatter in ipairs(formatters) do
  table.insert(sources, formatter)
end

require('mason').setup({})

require('mason-lspconfig').setup({
  ensure_installed = sources,
})
