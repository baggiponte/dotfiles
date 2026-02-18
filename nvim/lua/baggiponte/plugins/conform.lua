local formatters_by_filetype = {
  lua = { 'stylua' },
  just = { 'just' },
  sh = { 'shfmt' },
}

local function wrap_args(original_args, prefix_args, original_cmd, self, ctx)
  local resolved_args = {}
  if type(original_args) == 'function' then
    resolved_args = original_args(self, ctx) or {}
  elseif original_args ~= nil then
    resolved_args = vim.deepcopy(original_args)
  end

  if type(resolved_args) == 'string' then
    local args = table.concat(vim.deepcopy(prefix_args), ' ')
    if resolved_args == '' then
      return string.format('%s %s', args, original_cmd)
    end
    return string.format('%s %s %s', args, original_cmd, resolved_args)
  end

  local args = vim.deepcopy(prefix_args)
  table.insert(args, original_cmd)
  if type(resolved_args) == 'table' then
    vim.list_extend(args, resolved_args)
  end
  return args
end

local function resolve_command(command, self, ctx)
  if type(command) == 'function' then
    return command(self, ctx)
  end
  return command
end

local function set_formatter_runner(formatter_name, runner_cmd, runner_prefix_args)
  local ok, formatter = pcall(require, 'conform.formatters.' .. formatter_name)
  if not ok or type(formatter) ~= 'table' then
    return nil
  end

  local original_command = formatter.command
  local original_args = formatter.args
  local original_range_args = formatter.range_args

  local wrapped_formatter = {
    command = runner_cmd,
    args = function(self, ctx)
      local original_cmd = resolve_command(original_command, self, ctx)
      if type(original_cmd) ~= 'string' or original_cmd == '' then
        original_cmd = formatter_name
      end
      return wrap_args(original_args, runner_prefix_args, original_cmd, self, ctx)
    end,
  }

  if original_range_args then
    wrapped_formatter.range_args = function(self, ctx)
      local original_cmd = resolve_command(original_command, self, ctx)
      if type(original_cmd) ~= 'string' or original_cmd == '' then
        original_cmd = formatter_name
      end
      return wrap_args(original_range_args, runner_prefix_args, original_cmd, self, ctx)
    end
  end

  return wrapped_formatter
end

return {
  'stevearc/conform.nvim',
  ft = {
    'lua',
    'just',
    'sh',
  },
  cmd = { 'ConformInfo' },
  -- This will provide type hinting with LuaLS
  ---@module "conform"
  ---@type conform.setupOpts
  opts = function()
    local configured_formatters = {}
    for _, ft_formatters in pairs(formatters_by_filetype) do
      if type(ft_formatters) == 'table' then
        for _, formatter_name in ipairs(ft_formatters) do
          configured_formatters[formatter_name] = true
        end
      end
    end

    local formatter_overrides = {}
    for formatter_name, _ in pairs(configured_formatters) do
      local wrapped_formatter = set_formatter_runner(formatter_name, 'mise', { 'x', '--' })
      if wrapped_formatter then
        formatter_overrides[formatter_name] = wrapped_formatter
      end
    end

    return {
      formatters_by_ft = formatters_by_filetype,
      formatters = formatter_overrides,
      format_on_save = { timeout_ms = 500, lsp_fallback = true },
    }
  end,
}
