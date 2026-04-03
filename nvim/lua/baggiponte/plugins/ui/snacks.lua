return {
  'folke/snacks.nvim',
  version = '2.22.0',
  priority = 1000,
  lazy = false,
  opts = {
    indent = {
      enabled = true,
      indent = {
        char = '┊',
      },
      scope = {
        char = '┊',
      },
      animate = { enabled = false },
    },
    input = { enabled = true },
    rename = { enabled = true },
    notifier = {
      enabled = true,
      top_down = false,
    },
  },
}
