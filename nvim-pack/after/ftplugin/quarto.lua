-- Inherit the Markdown settings. There is no ftplugin/rmarkdown.lua anywhere
-- on the runtimepath, so the old `runtime! ftplugin/rmarkdown.lua` was a
-- no-op; the Markdown options live in ./markdown.lua.
-- The builtin quarto ftplugin already chains to rmd.vim for R-specific stuff.
vim.cmd('runtime! ftplugin/markdown.lua')
vim.cmd([[runtime! ftplugin/rmarkdown.lua]])
