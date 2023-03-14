return {
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = { 'MunifTanjim/nui.nvim' },
    opts = {
      cmdline = { enabled = true },
      messages = { enabled = false },
      lsp = {
        progress = { enabled = false },
        message = { enabled = true },
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          -- ['cmp.entry.get_documentation'] = true,
        },
      },
    },
    presets = {
      inc_rename = true,
      lsp_doc_border = true,
    },
  },
}
