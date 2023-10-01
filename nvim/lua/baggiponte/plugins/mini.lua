local safe_require = require('baggiponte.utils').safe_require

return {
  {
    'echasnovski/mini.comment',
    version = false,
    keys = {
      { 'gcc', mode = { 'n', 'v' } },
      { 'gc', mode = { 'n', 'v' } },
    },
    config = function()
      safe_require('mini.comment').setup({})
    end,
  },
  {
    'echasnovski/mini.splitjoin',
    version = false,
    keys = { 'gss' },
    config = function()
      safe_require('mini.splitjoin').setup({
        mappings = {
          toggle = 'gss',
        },
      })
    end,
  },
  {
    'Wansmer/treesj',
    keys = { '<space>m', '<space>j', '<space>s' },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
      max_join_length = 480,
    },
  },
}
