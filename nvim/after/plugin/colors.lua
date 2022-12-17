-- gruvbox-material.nvim

vim.g.gruvbox_material_transparent_background = 1
vim.cmd([[colorscheme gruvbox-material]])

for _, element in ipairs({ 'FloatBorder', 'NormalFloat', 'Normal' }) do
  vim.api.nvim_set_hl(0, element, { bg = 'none' })
end
