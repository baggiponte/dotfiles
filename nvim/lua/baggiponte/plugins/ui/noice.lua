return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  dependencies = { 'MunifTanjim/nui.nvim' },
  opts = {
    cmdline = { enabled = true },
    popupmenu = { enabled = true },
    notify = { enabled = false },
    lsp = {
      enabled = false,
      hover = { enabled = false },
    },
  },
}
