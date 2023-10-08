return {
  'TobinPalmer/rayso.nvim',
  cmd = { 'Rayso' },
  opts = {
    open_cmd = 'arc',
    options = {
      logging_path = vim.fn.expand('XDG_STATE_HOME') .. 'nvim/rayso',
      logging_file = 'rayso.log',
    },
  },
}
