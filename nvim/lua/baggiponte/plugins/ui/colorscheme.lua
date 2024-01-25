return {
  {
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

      for _, element in ipairs({ 'FloatBorder', 'NormalFloat', 'Normal' }) do
        vim.api.nvim_set_hl(0, element, { bg = 'none' })
      end
    end,
  },
  {
    'AlexvZyl/nordic.nvim',
    lazy = true,
    opts = {
      transparent_bg = true,
      bright_border = true,
      style = 'classic',
      telescope = {
        style = 'classic',
      },
    },
  },
  {
    'HoNamDuong/hybrid.nvim',
    opts = {
      transparent = true,
    },
  },
  {
    'nvchad/nvim-colorizer.lua',
    cmd = 'ColorizerToggle',
    name = 'colorizer',
    config = true,
  },
}
