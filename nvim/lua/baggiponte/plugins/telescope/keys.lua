return {
  {
    '<leader>ff',
    function()
      require('telescope.builtin').find_files()
    end,
    desc = 'Telescope find files',
    silent = true,
    noremap = true,
  },
  {
    '<leader>fg',
    function()
      require('telescope.builtin').live_grep()
    end,
    desc = 'Telescope find symbol using grep',
    silent = true,
    noremap = true,
  },
  {
    '<leader>fb',
    function()
      require('telescope.builtin').buffers()
    end,
    desc = 'Telescope find buffer',
    silent = true,
    noremap = true,
  },
  {
    '<leader>fd',
    function()
      require('telescope.builtin').diagnostics()
    end,
    desc = 'Telescope find in workspace diagnostics',
    silent = true,
    noremap = true,
  },
  {
    '<leader>fh',
    function()
      require('telescope.builtin').help_tags()
    end,
    desc = 'Telescope help tags',
    silent = true,
    noremap = true,
  },
  {
    '<leader>fw',
    function()
      require('telescope.builtin').grep_string()
    end,
    desc = 'Telescope grep string',
    silent = true,
    noremap = true,
  },
  {
    '<leader>fp',
    function()
      require('telescope').extensions.file_browser.file_browser()
    end,
    desc = 'Telescope buffers',
    silent = true,
    noremap = true,
  },
}
