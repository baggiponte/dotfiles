local runner = require('baggiponte.runner')

local linters_by_filetype = {
  sh = { 'shellcheck' },
  dockerfile = { 'hadolint' },
}

-- actionlint only makes sense for GitHub Actions workflows, which are plain
-- `yaml` buffers, so it is picked by path rather than by filetype.
---@param bufnr integer
---@return boolean
local function is_workflow(bufnr)
  return vim.api.nvim_buf_get_name(bufnr):match('/%.github/workflows/[^/]+%.ya?ml$') ~= nil
end

-- Cheap enough to set up eagerly: linting only runs from the autocmd below.
do
  local lint = require('lint')

  local names = { actionlint = true }
  for _, ft_linters in pairs(linters_by_filetype) do
    for _, name in ipairs(ft_linters) do
      names[name] = true
    end
  end
  for name in pairs(names) do
    lint.linters[name] = runner.linter(lint.linters[name], 'mise')
  end

  lint.linters_by_ft = linters_by_filetype

  vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost', 'InsertLeave' }, {
    group = vim.api.nvim_create_augroup('nvim-lint', { clear = true }),
    callback = function(args)
      lint.try_lint()
      if is_workflow(args.buf) then
        lint.try_lint('actionlint')
      end
    end,
  })
end
