return {
  'lukas-reineke/indent-blankline.nvim',
  main = 'ibl',
  event = { 'BufReadPost', 'BufNewFile' },
  opts = {
    indent = {
      char = '┊',
    },
    scope = {
      enabled = true,
      show_start = false,
      show_end = false,
    },
    exclude = {
      filetypes = {
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
      },
      buftypes = { 'terminal' },
    },
  },
}
