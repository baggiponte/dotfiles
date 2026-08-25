local runner = require('baggiponte.lsp.runner')

local linters_by_filetype = {
  sh = { 'shellcheck' },
  docker = { 'hadolint' },
  ['yaml.ghaction'] = { 'actionlint' },
}

return {
  'mfussenegger/nvim-lint',
  event = 'BufReadPost',
  config = function()
    local lint = require('lint')

    local configured_linters = {}
    for _, ft_linters in pairs(linters_by_filetype) do
      for _, linter_name in ipairs(ft_linters) do
        configured_linters[linter_name] = true
      end
    end

    for linter_name, _ in pairs(configured_linters) do
      lint.linters[linter_name] = runner.linter(lint.linters[linter_name], 'mise')
    end

    lint.linters_by_ft = linters_by_filetype

    vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost', 'InsertLeave' }, {
      group = vim.api.nvim_create_augroup('nvim-lint', { clear = true }),
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
