return {
  {
    'folke/trouble.nvim',
    cmd = { 'TroubleToggle' },
    dependencies = 'nvim-web-devicons',
    keys = {
      {
        '<leader>sw',
        '<cmd>TroubleToggle workspace_diagnostics<cr>',
        desc = '[s]how [w]orkspace diagnostics',
      },
      {
        '<leader>sd',
        '<cmd>TroubleToggle document_diagnostics<cr>',
        desc = '[s]how [d]ocument diagnostics',
      },
      { '<leader>sl', '<cmd>TroubleToggle loclist<cr>', desc = '[s]how [l]oclist diagnostics' },
      { '<leader>sq', '<cmd>TroubleToggle quickfix<cr>', desc = '[s]how [q]uickfix diagnostics' },
    },
    opts = {
      -- position = 'right',
      use_diagnostic_signs = true,
    },
  },
  {
    'folke/todo-comments.nvim',
    cmd = { 'TodoTrouble', 'TodoTelescope' },
    config = true,
    -- stylua: ignore
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next [t]odo comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous [t]odo comment" },
      { "<leader>st", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
      { "<leader>sT", "<cmd>TodoTelescope<cr>", desc = "[s]how [t]odos using Telescope" },
      { "<leader>sf", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
    },
  },
}
