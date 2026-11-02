local defer = require('baggiponte.defer')

-- oil has no plugin/ file: `:Oil` only exists after setup().
local setup = defer.loader({ 'nvim-web-devicons', 'oil.nvim' }, function()
  require('oil').setup({
    keymaps = {
      h = { 'actions.parent', mode = 'n' },
      l = {
        callback = function()
          -- Like `actions.select`, but never opens files: `l` only descends.
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
      is_always_hidden = function(name)
        return name == '.git'
      end,
    },
  })
end)

defer.on_cmd({ 'Oil' }, setup)
defer.on_keys({
  {
    '<leader>o',
    function()
      require('oil').open(nil, { preview = { vertical = true, split = 'botright' } })
    end,
    desc = 'oil.nvim: open with preview',
  },
  {
    '<C-f><C-d>',
    function()
      require('oil').open(vim.fn.getcwd())
    end,
    desc = 'oil.nvim: open the file explorer in the current directory',
  },
}, setup)
