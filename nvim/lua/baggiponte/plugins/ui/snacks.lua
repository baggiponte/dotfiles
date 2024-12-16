return {
  'folke/snacks.nvim',
  version = '2.11.0',
  priority = 1000,
  lazy = false,
  opts = {
    indent = {
      enabled = true,
      char = '┊', -- does not seem to work
      animate = { enabled = false },
    },
    input = { enabled = true },
    notifier = {
      enabled = true,
      top_down = false,
    },
  },
}
