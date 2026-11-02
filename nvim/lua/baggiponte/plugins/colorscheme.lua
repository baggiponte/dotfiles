vim.g.gruvbox_material_better_performance = 1
vim.g.gruvbox_material_diagnostic_virtual_text = 'highlighted'
vim.g.gruvbox_material_enable_italic = 1
vim.g.gruvbox_material_transparent_background = 2
vim.cmd.colorscheme('gruvbox-material')

-- Let floats and the popup menu show the terminal's (transparent) background.
for _, element in ipairs({ 'PMenu', 'FloatBorder', 'NormalFloat' }) do
  vim.api.nvim_set_hl(0, element, { bg = 'none' })
end
