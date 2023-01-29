return {
  'lukas-reineke/indent-blankline.nvim',
  opts = {
    char = '┊',
    show_current_context = true,
    show_current_context_start = false,
    use_treesitter = true,
    buftype_exclude = { 'terminal' },
    filetype_exclude = { 'help', 'packer', 'TelescopePrompt' },
  },
}
