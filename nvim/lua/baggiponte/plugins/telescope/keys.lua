local import = require('baggiponte.utils').import

return {
  {
    '<leader>v',
    function()
      vim.cmd([[vsp %:p:h]])
      import('telescope.builtin').find_files({ path = '%:p:h ' })
    end,
    desc = 'Split window vertically and find files',
    silent = true,
    noremap = true,
  },
  {
    '<leader>V',
    function()
      vim.cmd([[sp %:p:h]])
      import('telescope.builtin').find_files({ path = '%:p:h ' })
    end,
    desc = 'Split window horizontally and find files',
    silent = true,
    noremap = true,
  },
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
    '<leader>fr',
    function()
      import('telescope').extensions.frecency.frecency()
    end,
    desc = 'Telescope find files with [fr]ecency',
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
  {
    '<leader>fs',
    function()
      import('telescope.builtin').symbols({ sources = { 'nerd' } })
    end,
    desc = 'Telescope [f]ind [s]ymbol',
    silent = true,
    noremap = true,
  },
}
