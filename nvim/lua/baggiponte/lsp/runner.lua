-- Wraps external tools (linters, formatters, LSP servers) so they run through a
-- runtime manager (mise / uvx / bunx) instead of whatever is on PATH.
--
-- Design goals:
--   * Declarative: the runner -> binary mapping lives in one table (M.runners),
--     and the per-filetype tables in conform.lua / lint.lua stay small and flat.
--   * Works on the fly: nothing is resolved at startup. `M.linter` / `M.formatter`
--     return closures that expand the argv lazily, exactly when a tool actually
--     runs, so formatters/linters that build their args from context (self, ctx)
--     keep working unchanged.
--
-- The convention for both nvim-lint and conform is: the tool's *binary* field
-- (`.cmd` / `.command`) is set to the runner, and the tool's `.args` are expanded
-- to  { runner_prefix..., original_binary, ...original_args }.

---@class baggiponte.lsp.runner.Runner
---@field bin string Manager binary name (e.g. "mise")
---@field prefix string[] Args prepended before the real command (e.g. {"x","--"})
local M = {}

M.runners = {
  mise = { bin = 'mise', prefix = { 'x', '--' } },
  uvx = { bin = 'uvx', prefix = {} },
  bunx = { bin = 'bunx', prefix = { '--yes' } },
}

-- Resolve a value that may be a function (evaluated with the runtime context `...`).
---@generic T
---@param v T|fun(...):T
---@return T
function M.resolve(v, ...)
  if type(v) == 'function' then
    return v(...)
  end
  return v
end

---@param name string|baggiponte.lsp.runner.Runner
---@return baggiponte.lsp.runner.Runner
local function get_runner(name)
  if type(name) == 'table' then
    return name
  end
  local r = M.runners[name]
  if not r then
    error(string.format('[baggiponte.lsp.runner] unknown runner %q', tostring(name)), 2)
  end
  return r
end

-- The runner's prefix as a fresh list (e.g. { "x", "--" } for mise).
---@param name string|baggiponte.lsp.runner.Runner
---@return string[]
function M.prefix(name)
  return vim.deepcopy(get_runner(name).prefix)
end

-- The args to hand to the runner binary so it executes `tool` with `args`.
--   * args nil        -> { <prefix...>, tool }
--   * args string     -> a single shell string "<prefix...> tool <args>"
--   * args list / fn  -> { <prefix...>, tool, <args...> }
-- `...` is forwarded to `tool`/`args` when they are functions (runtime ctx).
---@param runner_name string|baggiponte.lsp.runner.Runner
---@param tool string|fun(...):string
---@param args string|table|fun(...):(string|table)|nil
---@param ... any Runtime context forwarded to function args
---@return string[]|string
function M.node(runner_name, tool, args, ...)
  local prefix = vim.deepcopy(get_runner(runner_name).prefix)
  local resolved_tool = M.resolve(tool, ...)
  local resolved_args = M.resolve(args, ...)

  if type(resolved_args) == 'string' then
    -- Single-shell-string form (rare; some conform formatters supply args as one string).
    local head = table.concat(prefix, ' ')
    if resolved_tool == '' then
      return head
    end
    if resolved_args == '' then
      return head .. ' ' .. resolved_tool
    end
    return head .. ' ' .. resolved_tool .. ' ' .. resolved_args
  end

  local node = vim.deepcopy(prefix)
  if resolved_tool ~= '' then
    table.insert(node, resolved_tool)
  end
  if type(resolved_args) == 'table' then
    vim.list_extend(node, resolved_args)
  end
  return node
end

-- Convenience: the full argv = { bin, ...node }, for tools that expect one argv.
---@param runner_name string|baggiponte.lsp.runner.Runner
---@param tool string|fun(...):string
---@param args string|table|fun(...):(string|table)|nil
---@param ... any
---@return string[]|string
function M.argv(runner_name, tool, args, ...)
  local node = M.node(runner_name, tool, args, ...)
  if type(node) == 'string' then
    return get_runner(runner_name).bin .. ' ' .. node
  end
  local argv = { get_runner(runner_name).bin }
  vim.list_extend(argv, node)
  return argv
end

-- Patch a single nvim-lint linter so it runs through a runner.
-- `linter` may be a table (with .cmd / .args) or a factory function returning
-- such a table (nvim-lint supports both). Returns a value of the same shape.
---@param linter table|fun(...):table
---@param runner_name string|baggiponte.lsp.runner.Runner
---@return table
function M.linter(linter, runner_name)
  local function patch(resolved)
    if type(resolved) ~= 'table' or type(resolved.cmd) ~= 'string' then
      return resolved
    end
    local original_cmd = resolved.cmd
    local original_args = resolved.args
    resolved.cmd = get_runner(runner_name).bin
    resolved.args = function(...)
      return M.node(runner_name, original_cmd, original_args, ...)
    end
    return resolved
  end

  if type(linter) == 'function' then
    return function(...)
      return patch(linter(...))
    end
  end
  return patch(linter)
end

-- Wrap a conform formatter so its `command` runs through a runner, preserving the
-- original `args` / `range_args` (including function-based ones).
---@param formatter table Conform formatter spec
---@param runner_name string|baggiponte.lsp.runner.Runner
---@return table
function M.formatter(formatter, runner_name)
  local r = get_runner(runner_name)
  local original_command = formatter.command
  local original_args = formatter.args
  local original_range_args = formatter.range_args

  local function build_args(args, self, ctx)
    local tool = M.resolve(original_command, self, ctx)
    if type(tool) ~= 'string' or tool == '' then
      return nil -- let conform fall back to its default command for this formatter
    end
    return M.node(runner_name, tool, args, self, ctx)
  end

  local wrapped = {
    command = r.bin,
    args = function(self, ctx)
      return build_args(original_args, self, ctx)
    end,
  }

  if original_range_args ~= nil then
    wrapped.range_args = function(self, ctx)
      return build_args(original_range_args, self, ctx)
    end
  end

  return wrapped
end

return M
