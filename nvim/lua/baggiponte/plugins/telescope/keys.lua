local import = require('baggiponte.utils').import

return {
  {
    '<leader>/',
    function()
      import('telescope.builtin').current_buffer_fuzzy_find()
    end,
    desc = 'Telescope fuzzy find within the current buffer',
    silent = true,
    noremap = true,
  },
  {
    '<leader>ff',
    function()
      import('telescope.builtin').find_files()
    end,
    desc = 'Telescope [f]ind [f]iles',
    silent = true,
    noremap = true,
  },
  {
    '<leader>fF',
    function()
      import('telescope.builtin').git_files()
    end,
    desc = 'Telescope [f]ind within git [F]iles',
    silent = true,
    noremap = true,
  },
  {
    '<leader>fg',
    function()
      import('telescope.builtin').live_grep()
    end,
    desc = 'Telescope [f]ind symbol using [g]rep',
    silent = true,
    noremap = true,
  },
  {
    '<leader>fb',
    function()
      import('telescope.builtin').buffers()
    end,
    desc = 'Telescope [f]ind [b]uffer',
    silent = true,
    noremap = true,
  },
  {
    '<leader>fd',
    function()
      import('telescope.builtin').diagnostics()
    end,
    desc = 'Telescope [f]ind in workspace [d]iagnostics',
    silent = true,
    noremap = true,
  },
  {
    '<leader>ft',
    function()
      vim.cmd("TodoTelescope cwd='%:p:h")
    end,
    desc = 'Telescope [f]ind within [t]odos',
    silent = true,
    noremap = true,
  },
}
