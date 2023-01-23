local noice_status, noice = pcall(require, 'noice')

if not noice_status then
  return
end

noice.setup({
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
      ['vim.lsp.util.stylize_markdown'] = true,
      ['cmp.entry.get_documentation'] = true,
    },
  },
  -- have messages (e.g. file saved)
  presets = {
    inc_rename = true,
    lsp_doc_border = true,
  },
  cmdline = { enabled = true },
  messages = { enabled = false },
})
