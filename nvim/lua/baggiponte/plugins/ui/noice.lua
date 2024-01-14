return {
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
      'MunifTanjim/nui.nvim',
      {
        'rcarriga/nvim-notify',
        opts = {
          render = 'compact',
          stages = 'slide',
          top_down = false,
          -- max_width = math.floor(vim.o.columns * 0.6),
        },
      },
    },
    opts = {
      cmdline = { enabled = true },
      messages = { enabled = true },
      lsp = {
        progress = { enabled = false },
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          -- ['cmp.entry.get_documentation'] = true,
        },
      },
      presets = {
        inc_rename = true,
        lsp_doc_border = true,
      },
    },
  },
}
