return {
  'mbbill/undotree',
  cmd = 'UndotreeToggle',
  config = function()
    vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = 'Toggle [u]ndoTree' })
  end,
}
