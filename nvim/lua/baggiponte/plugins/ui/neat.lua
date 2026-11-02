-- neat.nvim replaces lualine (statusline), noice (cmdline), dressing (select)
-- and snacks (input, notifier, indent, rename). The `snacks` backends are
-- snacks.nvim code vendored into neat: snacks.nvim itself is not installed.
-- LSP progress is shown by the statusline's `lsp_progress` component.
require('neat').setup({
  statusline = { enabled = true },
  cmdline = { enabled = true },
  select = { enabled = true },
  input = { enabled = true },
  notify = {
    enabled = true,
    backend = 'snacks',
    snacks = { top_down = false },
  },
  indent = {
    enabled = true,
    backend = 'snacks',
    snacks = {
      indent = { char = '┊' },
      scope = { char = '┊' },
    },
  },
})
