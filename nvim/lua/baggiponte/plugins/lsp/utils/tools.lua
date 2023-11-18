local import = require('baggiponte.utils').import

local servers = vim.tbl_keys(import('baggiponte.plugins.lsp.utils.servers'))

local linters = {
  'actionlint',
  'jsonlint',
  'ruff',
  'selene',
  'shellcheck',
  'tfsec',
  'yamllint',
  -- 'cfn-lint',
}

local formatters = {
  'jq',
  'shfmt',
  'stylua',
}

local dap = {
  'debugpy',
}

local M = vim.tbl_flatten(vim.tbl_deep_extend('force', {}, { dap, servers, linters, formatters }))

return M
