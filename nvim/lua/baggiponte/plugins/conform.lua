local formatters_by_filetype = {
  lua = { 'stylua' },
  just = { 'just' },
  sh = { 'shfmt' },
  css = { 'biome' },
  json = { 'biome' },
}

return {
  'stevearc/conform.nvim',
  ft = {
    'lua',
    'just',
    'sh',
    'json',
    'css',
  },
  cmd = { 'ConformInfo' },
  -- This will provide type hinting with LuaLS
  ---@module "conform"
  ---@type conform.setupOpts
  opts = {
    formatters_by_ft = formatters_by_filetype,
    format_on_save = { timeout_ms = 500, lsp_fallback = true },
  },
}
