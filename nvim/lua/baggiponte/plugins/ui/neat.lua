-- neat.nvim replaces lualine (statusline), noice (cmdline), dressing (select)
-- and snacks (input, notifier, indent, rename). The `builtin` notify and
-- indent backends are snacks.nvim code that ships inside neat, so snacks.nvim
-- is not installed. LSP progress is shown by the statusline's `lsp_progress`.
require('neat').setup({
  statusline = { enabled = true },
  cmdline = { enabled = true },
  select = { enabled = true },
  input = { enabled = true },
  notify = {
    enabled = true,
    backend = 'builtin',
    builtin = { top_down = false },
  },
  indent = {
    enabled = true,
    backend = 'builtin',
    builtin = {
      indent = { char = '┊' },
      scope = { char = '┊' },
    },
  },
})
