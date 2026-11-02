vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.wrap = true

-- Loading the spell file costs ~8 ms; enable spell after the first redraw.
local buf = vim.api.nvim_get_current_buf()
local win = vim.api.nvim_get_current_win()
vim.schedule(function()
  if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == buf then
    vim.api.nvim_win_call(win, function()
      vim.opt_local.spell = true
    end)
  end
end)
