return {
  'lukas-reineke/indent-blankline.nvim',
  event = 'BufReadPre',
  config = function()
    require('indent_blankline').setup({
      char = '┊',
      show_current_context = true,
      show_current_context_start = false,
      use_treesitter = true,
      buftype_exclude = { 'terminal' },
      filetype_exclude = { 'help', 'packer', 'TelescopePrompt' },
    })
  end,
}
