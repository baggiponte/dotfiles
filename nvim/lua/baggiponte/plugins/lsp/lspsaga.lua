local import = require('baggiponte.utils').import
local icons = import('baggiponte.utils.icons').icons

return {
  'nvimdev/lspsaga.nvim',
  cmd = { 'Lspsaga' },
  enabled = false,
  dependencies = {
    { 'nvim-tree/nvim-web-devicons' },
    { 'nvim-treesitter/nvim-treesitter' }, -- install markdown and markdown_inline parser
  },
  opts = {
    lightbulb = { enable = false },
    symbol_in_winbar = { enable = false },
    beacon = { enable = false },
    ui = { border = 'rounded', code_action = icons.diagnostics.Hint },
    definition = {
      vsplit = '<C-v>',
    },
  },
}
