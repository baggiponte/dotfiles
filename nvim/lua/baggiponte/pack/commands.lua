-- vim.pack.update() opens a review buffer: `:w` applies the changes, `:q` cancels.
-- Nothing in that buffer says so, so spell it out in its winbar.
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('baggiponte.pack.review', { clear = true }),
  pattern = 'nvim-pack',
  callback = function()
    vim.wo[0][0].winbar = '%#DiagnosticWarn# Nothing is applied yet: '
      .. '%#DiagnosticOk#:w%#DiagnosticWarn# applies the updates, '
      .. '%#DiagnosticError#:q%#DiagnosticWarn# cancels '
      .. '%#Comment# ]] [[ jump between plugins %*'
  end,
})

-- Updated plugins only take effect after a restart: say so once per update.
local updated = {}
vim.api.nvim_create_autocmd('PackChanged', {
  group = vim.api.nvim_create_augroup('baggiponte.pack.restart', { clear = true }),
  callback = function(ev)
    if ev.data.kind ~= 'update' then
      return
    end
    if #updated == 0 then
      -- after vim.pack's own "Applying updates" progress message
      vim.defer_fn(function()
        vim.notify(('vim.pack: updated %s. Run :restart to load the new code.'):format(table.concat(updated, ', ')))
        updated = {}
      end, 200)
    end
    updated[#updated + 1] = ev.data.spec.name
  end,
})
local function plugin_names()
  return vim.tbl_map(function(plugin)
    return plugin.spec.name
  end, vim.pack.get())
end

---@param args vim.api.keyset.create_user_command.command_args
local function names_or_all(args)
  return #args.fargs > 0 and args.fargs or nil
end

vim.api.nvim_create_user_command('PackUpdate', function(args)
  vim.pack.update(names_or_all(args), { force = args.bang })
end, {
  nargs = '*',
  bang = true,
  complete = plugin_names,
  desc = 'Fetch and review plugin updates (all, or the given plugins); ! applies without review',
})

vim.api.nvim_create_user_command('PackStatus', function(args)
  vim.pack.update(names_or_all(args), { offline = true })
end, {
  nargs = '*',
  complete = plugin_names,
  desc = 'Show installed plugins and already-fetched pending changes, without downloading',
})

vim.api.nvim_create_user_command('PackRestore', function(args)
  vim.pack.update(names_or_all(args), { target = 'lockfile', force = args.bang })
end, {
  nargs = '*',
  bang = true,
  complete = plugin_names,
  desc = 'Check out the revisions in nvim-pack-lock.json (e.g. after pulling the dotfiles)',
})

vim.api.nvim_create_user_command('PackClean', function()
  local unused = vim.tbl_map(
    function(plugin)
      return plugin.spec.name
    end,
    vim.tbl_filter(function(plugin)
      return not plugin.active
    end, vim.pack.get())
  )
  if #unused == 0 then
    vim.notify('vim.pack: no unused plugins')
    return
  end
  -- a picker (telescope via neat's vim.ui.select): all of them, or one at a
  -- time; picking is the confirmation and <Esc> cancels
  local all = ('All %d unused plugins'):format(#unused)
  local items = #unused > 1 and vim.list_extend({ all }, unused) or unused
  vim.ui.select(items, { prompt = 'Delete unused plugin' }, function(choice)
    if choice then
      vim.pack.del(choice == all and unused or { choice })
    end
  end)
end, { desc = 'Delete installed plugins that are no longer in the config' })
