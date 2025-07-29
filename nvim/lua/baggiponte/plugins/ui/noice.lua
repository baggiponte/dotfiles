return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  dependencies = { 'MunifTanjim/nui.nvim' },
  opts = {
    cmdline = { enabled = true },
    notify = { enabled = false },
    lsp = {
      enabled = false,
      hover = { enabled = false },
      signature = { enabled = false },
    },
  },
  presets = {
    lsp_doc_border = false, -- add a border to hover docs and signature help
  },
}
