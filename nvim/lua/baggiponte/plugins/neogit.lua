return {
  'NeogitOrg/neogit',
  dependencies = {
    'nvim-lua/plenary.nvim', -- required
    'sindrets/diffview.nvim', -- optional - Diff integration

    -- Only one of these is needed.
    'nvim-telescope/telescope.nvim', -- optional
    -- 'ibhagwan/fzf-lua',              -- optional
    -- 'echasnovski/mini.pick',         -- optional
    -- 'folke/snacks.nvim',             -- optional
  },
  cmd = 'Neogit',
  keys = {
    {
      '<leader>g',
      '<cmd>Neogit<CR>',
      mode = { 'n', 'v' },
      desc = 'Neogit: toggle git status window',
    },
    {
      '<leader>gc',
      '<cmd>Neogit commit<CR>',
      mode = { 'n', 'v' },
      desc = 'Neogit: git commit',
    },
  },
}
