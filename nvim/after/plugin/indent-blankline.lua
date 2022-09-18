require('indent_blankline').setup({
  -- for example, context is off by default, use this to turn it on
  char = '┊',
  show_current_context = true,
  show_current_context_start = false,
  use_treesitter = true,
  buftype_exclude = { 'terminal' },
  filetype_exclude = { 'help', 'packer', 'TelescopePrompt' },
})
