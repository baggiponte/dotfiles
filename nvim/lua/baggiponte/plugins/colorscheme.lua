return {
  {
    'sainnhe/gruvbox-material',
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.gruvbox_material_transparent_background = 1
      vim.cmd([[colorscheme gruvbox-material]])

      for _, element in ipairs({ 'FloatBorder', 'NormalFloat', 'Normal' }) do
        vim.api.nvim_set_hl(0, element, { bg = 'none' })
      end
    end,
  },
  { 'ellisonleao/gruvbox.nvim' },
}
