return {
  {
    'echasnovski/mini.comment',
    version = false,
    keys = {
      { 'gcc', mode = { 'n', 'v' } },
      { 'gc', mode = { 'n', 'v' } },
    },
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
    'echasnovski/mini.bufremove',
    -- stylua: ignore
    keys = {
      {
        "q",
        function()
          require("mini.bufremove").delete(0, false)
        end,
        desc = "Delete the current buffer"
      },
      {
        "<C-q>",
        function() require("mini.bufremove").delete(0, true) end,
        desc = "Force delete the current buffer."
      },
      { "Q",     "<cmd>quit<CR>",  desc = "[Q]uit neovim" },
      { "<C-Q>", "<cmd>quit!<CR>", desc = "Force [Q]uit neovim" },
    },
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
