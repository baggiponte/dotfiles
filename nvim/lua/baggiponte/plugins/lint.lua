local linters = {
  sh = { 'shellcheck' },
  docker = { 'hadolint' },
  ['yaml.ghaction'] = { 'actionlint' },
}

return {
  'mfussenegger/nvim-lint',
  event = 'BufReadPost',
  config = function()
    -- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/linting.lua
    local lint = require('lint')

    local function wrap_args(original_args, prefix_args, original_cmd, ...)
      local resolved_args = {}
      if type(original_args) == 'function' then
        resolved_args = original_args(...) or {}
      elseif type(original_args) == 'table' then
        resolved_args = vim.deepcopy(original_args)
      end
      return vim.list_extend(vim.list_extend(vim.deepcopy(prefix_args), { original_cmd }), resolved_args)
    end

    local function set_linter_runner(linter_name, runner_cmd, runner_prefix_args)
      local linter = lint.linters[linter_name]
      if type(linter) == 'function' then
        local original = linter
        lint.linters[linter_name] = function(...)
          local resolved_linter = original(...)
          if not resolved_linter or type(resolved_linter.cmd) ~= 'string' then
            return resolved_linter
          end
          local original_cmd = resolved_linter.cmd
          local original_args = resolved_linter.args
          resolved_linter.cmd = runner_cmd
          resolved_linter.args = function(...)
            return wrap_args(original_args, runner_prefix_args, original_cmd, ...)
          end
          return resolved_linter
        end
        return
      end

      if type(linter) ~= 'table' or type(linter.cmd) ~= 'string' then
        return
      end

      local original_cmd = linter.cmd
      local original_args = linter.args
      linter.cmd = runner_cmd
      linter.args = function(...)
        return wrap_args(original_args, runner_prefix_args, original_cmd, ...)
      end
    end

    local configured_linters = {}
    for _, ft_linters in pairs(linters) do
      for _, linter_name in ipairs(ft_linters) do
        configured_linters[linter_name] = true
      end
    end

    for linter_name, _ in pairs(configured_linters) do
      set_linter_runner(linter_name, 'mise', { 'x', '--' })
    end

    lint.linters_by_ft = linters

    vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost', 'InsertLeave' }, {
      group = vim.api.nvim_create_augroup('nvim-lint', { clear = true }),
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
