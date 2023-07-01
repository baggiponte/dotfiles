local icons = require('baggiponte.utils.icons').icons

return {
  'glepnir/lspsaga.nvim',
  cmd = { 'Lspsaga' },
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
