return {
  'folke/todo-comments.nvim',
  cmd = { 'TodoTrouble', 'TodoTelescope' },
  config = true,
    -- stylua: ignore
    keys = {
        { "]t",         function() require("todo-comments").jump_next() end, desc = "Next [t]odo comment" },
        { "[t",         function() require("todo-comments").jump_prev() end, desc = "Previous [t]odo comment" },
        { "<leader>st", "<cmd>TodoTrouble<cr>",                              desc = "Todo (Trouble)" },
        { "<leader>sT", "<cmd>TodoTelescope<cr>",                            desc = "[s]how [t]odos using Telescope" },
        { "<leader>sf", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>",      desc = "Todo/Fix/Fixme (Trouble)" },
    },
}
