return {
  'folke/noice.nvim',
  event = 'VimEnter',
  dependencies = { 'MunifTanjim/nui.nvim' },
  config = function()
    require('noice').setup({
      cmdline = { enabled = true },
      messages = { enabled = false },
      lsp = {
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          -- ['cmp.entry.get_documentation'] = true,
        },
        hover = { enabled = true },
        signature = { enabled = true },
        message = { enabled = true },
        documentation = { enabled = true },
      },
      presets = {
        inc_rename = true, -- requires inc-rename.nvim
        lsp_doc_border = true,
      },
    })
  end,
}
