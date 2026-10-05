return {
  'stevearc/oil.nvim',
  cmd = 'Oil',
  keys = {
    {
      '<leader>o',
      function()
        require('oil').open(nil, { preview = { vertical = true, split = 'botright' } })
      end,
      desc = 'oil.nvim: open with preview',
    },
  },
  opts = {
    keymaps = {
      h = { 'actions.parent', mode = 'n' },
      l = {
        callback = function()
          local oil = require('oil')
          local entry = oil.get_cursor_entry()
          local link_stat = entry and entry.meta and entry.meta.link_stat
          if entry and (entry.type == 'directory' or (link_stat and link_stat.type == 'directory')) then
            oil.select()
          end
        end,
        desc = 'Enter directory',
        mode = 'n',
      },
    },
    preview_win = {
      update_on_cursor_moved = true,
    },
    view_options = {
      show_hidden = true,
      is_always_hidden = function(name, bufnr)
        local must_hide = { '.git' }

        for _, v in pairs(must_hide) do
          if name == v then
            return true
          end
        end
      end,
    },
  },
  -- Optional dependencies
  dependencies = { 'nvim-tree/nvim-web-devicons' },
}
