-- Run linters and formatters through a runtime manager instead of whatever
-- is on PATH, so they come at the version mise / uv / bun resolves for the
-- project. The tool's own command moves into the args:
--   shellcheck -f json  ->  mise x -- shellcheck -f json
local M = {}

---@type table<string, string[]> runner -> argv that goes before the tool
local prefixes = {
  mise = { 'mise', 'x', '--' },
  uvx = { 'uvx' },
  bunx = { 'bunx', '--yes' },
}

--- The runner's argv after its binary, followed by `tool`.
---@param runner string
---@param tool string
---@return string[]
local function head(runner, tool)
  local args = vim.list_slice(assert(prefixes[runner], 'unknown runner ' .. runner), 2)
  table.insert(args, tool)
  return args
end

--- Wrap an nvim-lint linter. nvim-lint evaluates function items in `args`,
--- so those keep working.
---@param linter table|fun():table nvim-lint linter, or a function returning one
---@param runner string
---@return table|fun():table
function M.linter(linter, runner)
  local function wrap(spec)
    return vim.tbl_extend('force', spec, {
      cmd = prefixes[runner][1],
      args = vim.list_extend(head(runner, spec.cmd), spec.args or {}),
    })
  end

  if type(linter) == 'function' then
    return function()
      return wrap(linter())
    end
  end
  return wrap(linter)
end

--- Wrap a conform formatter. Only `command`, `args` and `range_args` are
--- returned: conform merges them over the built-in spec for everything else.
---@param formatter conform.FileFormatterConfig built-in conform spec
---@param runner string
---@return table
function M.formatter(formatter, runner)
  local function wrap(args)
    if args == nil then
      return nil
    end
    return function(self, ctx)
      local resolved = type(args) == 'function' and args(self, ctx) or args
      return vim.list_extend(head(runner, formatter.command), resolved)
    end
  end

  return {
    command = prefixes[runner][1],
    args = wrap(formatter.args),
    range_args = wrap(formatter.range_args),
  }
end

return M
