local tsopts = {

  ensure_installed = {
    'arduino',
    'bash',
    'dockerfile',
    'gitattributes',
    'gitignore',
    'help',
    'json',
    'jsonc',
    'julia',
    'lua',
    'make',
    'markdown',
    'markdown_inline',
    'python',
    'r',
    'regex', -- needed for noice.nvim
    'sql',
    'toml',
    'yaml',
  },

  indent = { enable = true },

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-]>',
      -- scope_incremental = '<tab>',
      node_incremental = '<c-]>',
      node_decremental = '<c-[>',
    },
  },

  autopairs = { enable = true },

  rainbow = {
    enable = true,
    -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    max_file_lines = nil, -- Do not enable for files with more than n lines, int
    -- colors = {}, -- table of hex strings
    -- termcolors = {} -- table of colour name strings
  },

  playground = { enable = true },

  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim.
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm.
        ['ib'] = '@block.inner', -- in markdown, it's fenced code blocks!
        ['ab'] = '@block.outer',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
        ['aC'] = '@comment.outer',
        ['ai'] = '@conditional.outer',
        ['ii'] = '@conditional.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['al'] = '@loop.outer',
        ['il'] = '@loop.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']f'] = '@function.outer',
        [']c'] = '@class.outer',
      },
      goto_next_end = {
        [']F'] = '@function.outer',
        [']C'] = '@class.outer',
      },
      goto_previous_start = {
        ['[f'] = '@function.outer',
        ['[c'] = '@class.outer',
      },
      goto_previous_end = {
        ['[F'] = '@function.outer',
        ['[C'] = '@class.outer',
      },
    },
  },

  endwise = { enable = true },
}

return {
  { 'nvim-treesitter/playground', cmd = 'TSPlaygroundToggle' },
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      { 'RRethy/nvim-treesitter-endwise' },
      { 'nvim-treesitter/nvim-treesitter-context' },
      { 'nvim-treesitter/nvim-treesitter-textobjects' },
      { 'p00f/nvim-ts-rainbow' },
      { 'windwp/nvim-autopairs', config = true },
      {
        'kylechui/nvim-surround',
        config = true,
      },
    },
    version = false, -- last release is way too old and doesn't work on Windows
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup(tsopts)
    end,
  },
}
