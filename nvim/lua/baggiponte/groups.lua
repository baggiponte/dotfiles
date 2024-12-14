local groups = {
  LspInfoBorder = 'White',
}

for group, hl in pairs(groups) do
  vim.api.nvim_set_hl(0, group, { link = hl })
end
