return {
  'utilyre/barbecue.nvim',
  enabled = false,
  event = 'LspAttach',
  name = 'barbecue',
  version = '*',
  dependencies = {
    'SmiteshP/nvim-navic',
    'nvim-tree/nvim-web-devicons', -- optional dependency
  },
  opts = {
    symbols = {
      separator = '',
    },
    exclude_filetypes = {
      'NvimTree',
      'TelescopePrompt',
      'Trouble',
      'fugitive',
      'git',
      'gitcommit',
      'help',
      'lazy',
      'lspinfo',
      'mason',
      'null-ls-info',
      'toggleterm',
    },
  },
}
