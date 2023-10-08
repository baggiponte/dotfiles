local safe_require = require('baggiponte.utils').safe_require

return {
  {
    '<leader>v',
    function()
      vim.cmd([[vsp %:p:h]])
      safe_require('telescope.builtin').find_files({ path = '%:p:h ' })
    end,
    desc = 'Split window vertically and find files',
    silent = true,
    noremap = true,
  },
  {
    '<leader>V',
    function()
      vim.cmd([[sp %:p:h]])
      safe_require('telescope.builtin').find_files({ path = '%:p:h ' })
    end,
    desc = 'Split window horizontally and find files',
    silent = true,
    noremap = true,
  },
  {
    '<leader>/',
    function()
      safe_require('telescope.builtin').current_buffer_fuzzy_find()
    end,
    desc = 'Telescope fuzzy find within the current buffer',
    silent = true,
    noremap = true,
  },
  {
    '<leader>ff',
    function()
      safe_require('telescope.builtin').find_files()
    end,
    desc = 'Telescope [f]ind [f]iles',
    silent = true,
    noremap = true,
  },
  {
    '<leader>fF',
    function()
      safe_require('telescope.builtin').git_files()
    end,
    desc = 'Telescope [f]ind within git [F]iles',
    silent = true,
    noremap = true,
  },
  {
    '<leader>fg',
    function()
      safe_require('telescope.builtin').live_grep()
    end,
    desc = 'Telescope [f]ind symbol using [g]rep',
    silent = true,
    noremap = true,
  },
  {
    '<leader>fb',
    function()
      safe_require('telescope.builtin').buffers()
    end,
    desc = 'Telescope [f]ind [b]uffer',
    silent = true,
    noremap = true,
  },
  {
    '<leader>fd',
    function()
      safe_require('telescope').extensions.file_browser.file_browser()
    end,
    desc = 'Telescope [f]ind in [d]irectory tree',
    silent = true,
    noremap = true,
  },
  {
    '<leader>fr',
    function()
      safe_require('telescope').extensions.frecency.frecency()
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
      safe_require('telescope.builtin').symbols({ sources = { 'nerd' } })
    end,
    desc = 'Telescope [f]ind [s]ymbol',
    silent = true,
    noremap = true,
  },
}
