vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2

-- Keybindings
vim.api.nvim_buf_set_keymap(0, 'i', '<C-i>', ' <- ', { noremap = true })
vim.api.nvim_buf_set_keymap(0, 'i', '<C-m>', ' %>%', { noremap = true })
