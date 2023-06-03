local check_executable = function(executable)
  if vim.fn.executable(executable) ~= 1 then
    vim.notify(executable .. ' not found on $PATH', vim.log.levels.ERROR)
  end
end

local create_repl = function(opts)
  local Terminal = require('toggleterm.terminal').Terminal
  return Terminal:new({ cmd = opts.command, hidden = opts.hidden, direction = opts.direction })
end

local check_pdm = function()
  check_executable('pdm')

  if vim.fs.find('.pdm-python', { upward = true, stop = vim.loop.os_homedir() }) ~= nil then
    return 1
  else
    vim.notify('Not in a PDM project', vim.log.levels.ERROR)
    return 0
  end
end

-- cmd('ToggleREPLAuto', function()
--   local filetypes = {
--     julia = 'julia',
--     lua = 'lua',
--     python = 'ipython',
--     quarto = 'radian',
--     r = 'radian',
--     rmd = 'radian',
--   }
--
--   local buffer_ft = vim.bo.filetype
--   local repl = filetypes[buffer_ft]
--
--   if repl == nil then
--     vim.notify('No REPL associated with current filetype', vim.log.levels.ERROR)
--   else
--     vim.cmd('ToggleREPL ' .. filetypes[buffer_ft])
--   end
-- end, {})

return {
  {
    name = 'ToggleLazyGit',
    callable = function()
      check_executable('lazygit')

      local repl = create_repl({ command = 'lazygit', direction = 'float', hidden = true })

      local size = math.floor(vim.o.columns * 0.4)
      repl:toggle(size)
    end,
    nargs = 0,
  },
  {
    name = 'ToggleIPython',
    callable = function()
      check_pdm()

      local repl = create_repl({ command = 'pdm run ipython', direction = 'vertical', hidden = false })

      repl:toggle(100)
    end,
    nargs = 0,
  },
  {
    name = 'ToggleREPL',
    callable = function(executable)
      check_executable(executable)

      local repl = create_repl({ command = executable, direction = 'vertical', hidden = true })

      local size = math.floor(vim.o.columns * 0.4)
      repl:toggle(size)
    end,
    nargs = 1,
  },
}
