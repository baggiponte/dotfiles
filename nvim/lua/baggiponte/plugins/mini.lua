return {
  {
    'echasnovski/mini.comment',
    version = false,
    keys = { 'gcc', 'gc' },
    config = function()
      require('mini.comment').setup({})
    end,
  },
  {
    'echasnovski/mini.splitjoin',
    version = false,
    keys = { 'gss' },
    config = function()
      require('mini.splitjoin').setup({
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
