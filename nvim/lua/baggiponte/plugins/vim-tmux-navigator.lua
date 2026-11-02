-- Vimscript plugin, only useful inside tmux. lazy.nvim's `enabled = false`
-- kept it off the runtimepath; here its plugin/ file is told to bail out.
if vim.env.TMUX == nil or vim.env.TMUX == '' then
  vim.g.loaded_tmux_navigator = 1
end
