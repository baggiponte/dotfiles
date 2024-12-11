return {
  {
    '<leader>ff',
    function()
      require('telescope.builtin').find_files()
    end,
    desc = 'Telescope [f]ind [f]iles',
    silent = true,
    noremap = true,
  },
  {
    '<leader>fg',
    function()
      require('telescope.builtin').live_grep()
    end,
    desc = 'Telescope [f]ind symbol using [g]rep',
    silent = true,
    noremap = true,
  },
  {
    '<leader>fb',
    function()
      require('telescope.builtin').buffers()
    end,
    desc = 'Telescope [f]ind [b]uffer',
    silent = true,
    noremap = true,
  },
  {
    '<leader>fd',
    function()
      require('telescope.builtin').diagnostics()
    end,
    desc = 'Telescope [f]ind in workspace [d]iagnostics',
    silent = true,
    noremap = true,
  },
  {
    '<leader>fh',
    function()
      require('telescope.builtin').help_tags()
    end,
    desc = 'Telescope [h]elp [t]ags',
    silent = true,
    noremap = true,
  },
  {
    '<leader>fw',
    function()
      require('telescope.builtin').grep_string()
    end,
    desc = 'Telescope [g]rep [s]tring',
    silent = true,
    noremap = true,
  },
}
