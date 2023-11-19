local linters = {
  fish = { 'fish' },
  json = { 'jsonlint' },
  lua = { 'selene' },
  python = { 'mypy' },
  sh = { 'shellcheck' },
  yaml = { 'yamllint', 'actionlint' },
  sql = { 'sqlfluff' },
  terraform = { 'tfsec' },
  ['*'] = { 'codespell' },
}

return {
  'mfussenegger/nvim-lint',
  enabled = false,
  event = 'BufReadPost',
  config = function()
    -- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/linting.lua
    local import = require('baggiponte.utils').import
    local lint = import('lint')

    lint.linters_by_ft = linters

    vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost', 'InsertLeave' }, {
      group = vim.api.nvim_create_augroup('nvim-lint', { clear = true }),
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
