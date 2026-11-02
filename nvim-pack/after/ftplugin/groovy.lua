-- Spell-check Jenkinsfiles (mapped to groovy in ../../filetype.lua).
-- Kept buffer-local: other groovy files stay spell-free.
if vim.fn.expand('%:t'):lower():find('jenkinsfile', 1, true) then
  vim.opt_local.spell = true
end
