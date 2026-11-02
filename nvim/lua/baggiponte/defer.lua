-- Load `opt` plugins (see baggiponte.pack) on an event, filetype, key or
-- command. They stay off the runtimepath until `M.loader()` packadds them.
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
---@return table<any, vim.api.keyset.get_autocmds.ret> autocmds by id
local function autocmds_by_id(event)
  local autocmds = {}
  for _, autocmd in ipairs(vim.api.nvim_get_autocmds({ event = event })) do
    -- autocmds defined from Vimscript have no id
    autocmds[autocmd.id or autocmd] = autocmd
  end
  return autocmds
end

--- Re-fire `args.event` for the autocmds created since `before`, in the
--- triggering buffer so <abuf>/args.buf match the original event.
---@param args vim.api.keyset.create_autocmd.callback_args
---@param before table<any, vim.api.keyset.get_autocmds.ret>
local function refire(args, before)
  local groups = {} ---@type table<integer, true>
  local before_groups = {} ---@type table<integer, true>
  for _, autocmd in pairs(before) do
    if autocmd.group then
      before_groups[autocmd.group] = true
    end
  end
  for id, autocmd in pairs(autocmds_by_id(args.event)) do
    if autocmd.group then
      if not before_groups[autocmd.group] then
        groups[autocmd.group] = true
      end
    elseif type(id) == 'number' and not before[id] and autocmd.callback then
      -- no group to target with nvim_exec_autocmds: call it directly
      vim.api.nvim_buf_call(args.buf, function()
        pcall(autocmd.callback, vim.tbl_extend('force', args, { id = id }))
      end)
    end
  end
  for group in pairs(groups) do
    vim.api.nvim_buf_call(args.buf, function()
      pcall(vim.api.nvim_exec_autocmds, args.event, {
        group = group,
        pattern = args.match,
        data = args.data,
        modeline = false,
      })
    end)
  end
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
--- The triggering event is then re-fired for the autocmds that `fn` created,
--- so the plugin also sees the event that loaded it.
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
      local before = autocmds_by_id(args.event)
      run()
      refire(args, before)
    end,
  })
end

--- Run `fn` on the first FileType in `filetypes`.
---@param filetypes string|string[]
---@param fn fun()
function M.on_ft(filetypes, fn)
  M.on_event('FileType', fn, filetypes)
end

--- Run `fn` once the UI is attached and the first screen is drawn. Never
--- fires in headless sessions.
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

--- Set up a plugin's keys; `setup` (optional) runs on the first press of any
--- of them. Each key is { lhs, rhs?, mode?, desc?, expr? }:
---   - with `rhs`, `lhs` is mapped to it;
---   - without, the plugin maps `lhs` itself in `setup`, so a stub stands in
---     until then and the first press is replayed to the plugin's mapping.
---@param keys {[1]: string, [2]?: string|function, mode?: string|string[], desc?: string, expr?: boolean}[]
---@param setup? fun()
function M.on_keys(keys, setup)
  local load = M.once(function()
    for _, key in ipairs(keys) do
      if key[2] == nil then
        pcall(vim.keymap.del, key.mode or 'n', key[1])
      end
    end
    if setup then
      setup()
    end
  end)

  for _, key in ipairs(keys) do
    local lhs, rhs, mode = key[1], key[2], key.mode or 'n'
    local opts = { desc = key.desc, expr = key.expr, silent = true }

    if rhs == nil then
      vim.keymap.set(mode, lhs, function()
        load()
        local count = vim.v.count > 0 and tostring(vim.v.count) or ''
        vim.api.nvim_feedkeys(count .. vim.keycode(lhs), 'im', false)
      end, { desc = 'Load plugin and run ' .. lhs })
    elseif not setup then
      vim.keymap.set(mode, lhs, rhs, opts)
    elseif type(rhs) == 'function' then
      vim.keymap.set(mode, lhs, function()
        load()
        return rhs()
      end, opts)
    else
      opts.expr = true
      vim.keymap.set(mode, lhs, function()
        load()
        return rhs
      end, opts)
    end
  end
end

--- A function that requires `module` and calls the function at `path` in it,
--- for keymaps that shouldn't load the plugin until they're pressed.
---   call('dap', 'continue')     -> require('dap').continue()
---   call('neotest', 'run.run')  -> require('neotest').run.run()
---@param module string
---@param path string dotted path to the function inside the module
---@param ... any arguments for the call
---@return fun(): any
function M.call(module, path, ...)
  local args = vim.F.pack_len(...)
  return function()
    local fn = vim.tbl_get(require(module), unpack(vim.split(path, '.', { plain = true })))
    return fn(vim.F.unpack_len(args))
  end
end

--- Make `require()` of a module from a not-yet-loaded `opt` plugin packadd
--- that plugin first, so optional integrations (e.g. fff -> devicons) work.
--- Hard dependencies are still listed in each M.loader() call: :packadd is
--- not allowed in every context (e.g. inside UI event callbacks).
---@param opt_paths table<string, string> `opt` plugin name -> install path
function M.load_on_require(opt_paths)
  -- lua top-level module -> plugin names. Several plugins can share one
  -- (telescope.nvim and telescope-fzf-native.nvim both ship lua/telescope/).
  local opt_plugins ---@type table<string, string[]>?

  table.insert(package.loaders, function(modname)
    if not opt_plugins then
      opt_plugins = {}
      for name, path in pairs(opt_paths) do
        for entry in vim.fs.dir(path .. '/lua') do
          local top = entry:gsub('%.lua$', '')
          opt_plugins[top] = opt_plugins[top] or {}
          table.insert(opt_plugins[top], name)
        end
      end
    end

    local top = modname:match('^[^.]+')
    local names = opt_plugins[top]
    if not names then
      return
    end
    opt_plugins[top] = nil
    for _, name in ipairs(names) do
      M.packadd(name)
    end
    local path = modname:gsub('%.', '/')
    local file = vim.api.nvim_get_runtime_file('lua/' .. path .. '.lua', false)[1]
      or vim.api.nvim_get_runtime_file('lua/' .. path .. '/init.lua', false)[1]
    return file and loadfile(file) or nil
  end)
end

return M
