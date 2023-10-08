return {
  'folke/trouble.nvim',
  cmd = { "TroubleToggle", "Trouble" },
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
}
