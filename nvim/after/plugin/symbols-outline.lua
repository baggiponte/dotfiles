local symbols_outline = require("symbols-outline")

-- setup
symbols_outline.setup({})

-- keymaps
local opts = { silent = true, noremap = true }
vim.keymap.set("n", "<leader>fs", symbols_outline.toggle_outline, opts)
