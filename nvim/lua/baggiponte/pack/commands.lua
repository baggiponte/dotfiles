-- Plugin management commands (what :Lazy used to provide). vim.pack.update()
-- opens a review buffer: `:w` applies the changes, `:q` cancels.
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
  if vim.fn.confirm('Delete unused plugins?\n' .. table.concat(unused, '\n'), '&Yes\n&No', 2) == 1 then
    vim.pack.del(unused)
  end
end, { desc = 'Delete installed plugins that are no longer in the config' })
