-- Small helpers to defer plugin loading, standing in for lazy.nvim's
-- `event`/`ft`/`keys`/`cmd` handlers. Plugins marked `opt` in baggiponte.pack
-- stay off the runtimepath until `M.loader()` packadds them.
local M = {}

--- Wrap `fn` so it runs at most once, however many triggers fire.
---@param fn fun()
---@return fun()
function M.once(fn)
  local done = false
  return function()
    if done then
      return
    end
    done = true
    fn()
  end
end

---@param event string
---@return table<integer, true>
local function autocmd_groups(event)
  local groups = {}
  for _, autocmd in ipairs(vim.api.nvim_get_autocmds({ event = event })) do
    if autocmd.group then
      groups[autocmd.group] = true
    end
  end
  return groups
end

local loaded = {} ---@type table<string, true>

--- packadd an `opt` plugin once (a second :packadd re-sources plugin/ files).
---@param name string
function M.packadd(name)
  if loaded[name] then
    return
  end
  loaded[name] = true
  vim.cmd.packadd(name)
end

--- Return a function that, on first call only, loads the `opt` plugins in
--- `plugins` (sourcing their plugin/ files) and then runs `fn`.
---@param plugins string[]
---@param fn? fun()
---@return fun()
function M.loader(plugins, fn)
  return M.once(function()
    for _, name in ipairs(plugins) do
      M.packadd(name)
    end
    if fn then
      fn()
    end
  end)
end

--- Run `fn` on the first of `events` (optionally restricted to `pattern`).
--- Like lazy.nvim, the triggering event is then re-fired for the autocmd
--- groups that `fn` created, so the plugin also sees the event that loaded it.
---@param events string|string[]
---@param fn fun()
---@param pattern? string|string[]
function M.on_event(events, fn, pattern)
  local run = M.once(fn)
  local group = vim.api.nvim_create_augroup('baggiponte-defer-' .. tostring(run), { clear = true })
  vim.api.nvim_create_autocmd(events, {
    group = group,
    pattern = pattern,
    callback = function(args)
      vim.api.nvim_del_augroup_by_id(group)
      local before = autocmd_groups(args.event)
      run()
      for new_group in pairs(autocmd_groups(args.event)) do
        if not before[new_group] then
          -- run in the triggering buffer so <abuf>/args.buf match the original
          vim.api.nvim_buf_call(args.buf, function()
            pcall(vim.api.nvim_exec_autocmds, args.event, {
              group = new_group,
              pattern = args.match,
              data = args.data,
              modeline = false,
            })
          end)
        end
      end
    end,
  })
end

--- Run `fn` on the first FileType in `filetypes` (lazy.nvim's `ft`).
---@param filetypes string|string[]
---@param fn fun()
function M.on_ft(filetypes, fn)
  M.on_event('FileType', fn, filetypes)
end

--- Equivalent of lazy.nvim's `VeryLazy`: after the UI attached and the first
--- screen was drawn. Never fires in headless sessions (same as lazy.nvim).
---@param fn fun()
function M.very_lazy(fn)
  vim.api.nvim_create_autocmd('UIEnter', {
    once = true,
    callback = function()
      vim.schedule(fn)
    end,
  })
end

--- Define user command stubs that run `setup` and then re-execute the command.
--- `setup` must (re)define the real commands, e.g. by packadd-ing the plugin.
---@param names string[]
---@param setup fun()
function M.on_cmd(names, setup)
  for _, name in ipairs(names) do
    vim.api.nvim_create_user_command(name, function(args)
      for _, n in ipairs(names) do
        pcall(vim.api.nvim_del_user_command, n)
      end
      setup()
      vim.cmd({
        cmd = name,
        args = args.fargs,
        bang = args.bang,
        range = args.range > 0 and { args.line1, args.line2 } or nil,
      })
    end, { nargs = '*', bang = true, range = true })
  end
end

--- Set keymaps from lazy.nvim-style key specs; `setup` runs before the first
--- use of any of them.
---@param keys table[]
---@param setup? fun()
function M.keys(keys, setup)
  for _, key in ipairs(keys) do
    local lhs, rhs = key[1], key[2]
    local opts = { desc = key.desc, expr = key.expr, silent = true }
    local mapped = rhs
    if setup then
      if type(rhs) == 'function' then
        mapped = function()
          setup()
          return rhs()
        end
      else
        mapped = function()
          setup()
          return rhs
        end
        opts.expr = true
      end
    end
    vim.keymap.set(key.mode or 'n', lhs, mapped, opts)
  end
end

return M
