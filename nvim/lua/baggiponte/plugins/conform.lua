-- TODO: retrieve formatters from Mason tool list
local formatters = {
  lua = { 'stylua' },
  just = { 'just' },
  sh = { 'shfmt' },
}

return {
  'stevearc/conform.nvim',
  ft = { 'lua', 'just', 'sh' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format({ async = true, lsp_fallback = true })
      end,
      mode = '',
      desc = 'Format buffer with conform.nvim',
    },
  },
  opts = {
    format_on_save = { timeout_ms = 500, lsp_fallback = true },
    formatters_by_ft = formatters,
  },
}
