-- local quarto = require("quarto")
--
-- vim.keymap.set("n", "<leader>qp", quarto.quartoPreview, { silent = true, noremap = true })

vim.cmd("let g:pandoc#syntax#conceal#blacklist=['codeblock_start','codeblock_delim']")
