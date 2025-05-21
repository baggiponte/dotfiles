local linters = {
  sh = { 'shellcheck' },
  docker = { 'hadolint' },
  ['yaml.ghaction'] = { 'actionlint', 'zizmor' },
  -- ['*'] = { 'codespell' },
}

return {
  'mfussenegger/nvim-lint',
  event = 'BufReadPost',
  config = function()
    -- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/linting.lua
    local lint = require('lint')

    lint.linters_by_ft = linters

    vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost', 'InsertLeave' }, {
      group = vim.api.nvim_create_augroup('nvim-lint', { clear = true }),
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
