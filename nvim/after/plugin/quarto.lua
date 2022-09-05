local quarto = require("quarto")

vim.keymap.set("n", "<leader>qp", quarto.quartoPreview, { silent = true, noremap = true })
