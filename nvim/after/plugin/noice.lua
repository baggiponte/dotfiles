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
  messages = { enabled = false },
  presets = {
    inc_rename = true,
    command_palette = true,
  },
})
