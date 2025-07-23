local keys = {
  {
    'gs',
    '<cmd>Namu symbols<cr>',
    desc = 'Jump to LSP symbol',
  },
  {
    'gS',
    '<cmd>Namu workspace<cr>',
    desc = 'LSP Symbols - Workspace',
  },
}

return {
  'bassamsdata/namu.nvim',
  opts = {},
  keys = keys,
}
