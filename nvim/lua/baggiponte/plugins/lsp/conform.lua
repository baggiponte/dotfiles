-- TODO: retrieve formatters from Mason tool list
local formatters = {
  lua = { 'stylua' },
  json = { 'jq' },
  just = { 'just' },
  sh = { 'shfmt' },
  ['*'] = { 'trim_whitespace', 'codespell' },
}

return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format({ async = true, lsp_fallback = true })
      end,
      mode = '',
      desc = '[F]ormat buffer with conform.nvim',
    },
  },
  opts = {
    format_on_save = { timeout_ms = 500, lsp_fallback = true },
    formatters_by_ft = formatters,
  },
}
