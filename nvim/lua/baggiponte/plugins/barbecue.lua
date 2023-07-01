return {
  'utilyre/barbecue.nvim',
  event = 'VeryLazy',
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
