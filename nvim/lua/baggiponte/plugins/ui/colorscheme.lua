return {
  'sainnhe/gruvbox-material',
  lazy = false,
  priority = 1000,
  config = function()
    -- defaults
    -- vim.g.gruvbox_material_background = 'medium'
    -- vim.g.gruvbox_material_diagnostic_line_highlight = 1
    -- vim.g.gruvbox_material_diagnostic_text_highlight = 0
    -- vim.g.gruvbox_material_disable_italic_comment = 0
    -- vim.g.gruvbox_material_enable_bold = 0
    -- vim.g.gruvbox_material_foreground = 'material'
    -- vim.g.gruvbox_material_ui_contrast = 'low'

    vim.g.gruvbox_material_better_performance = 1
    vim.g.gruvbox_material_diagnostic_virtual_text = 'highlighted'
    vim.g.gruvbox_material_enable_italic = 1
    vim.g.gruvbox_material_transparent_background = 2
    vim.cmd([[colorscheme gruvbox-material]])

    for _, element in ipairs({ 'PMenu', 'FloatBorder', 'NormalFloat' }) do
      vim.api.nvim_set_hl(0, element, { bg = 'none' })
    end
  end,
}
