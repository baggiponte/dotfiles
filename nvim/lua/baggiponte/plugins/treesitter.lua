local parsers = {
  -- 'arduino',
  'bash',
  'dockerfile',
  'gitattributes',
  'gitignore',
  'ini',
  'json',
  -- 'jsonc', -- unsupported on nvim-treesitter main
  -- 'julia',
  'just',
  -- 'kdl',
  'lua',
  'make',
  'markdown',
  'markdown_inline',
  'python',
  'r',
  'regex',
  'requirements',
  'rust',
  'sql',
  'terraform',
  'tmux',
  'toml',
  'vimdoc',
  'yaml',
}

local textobjects = {
  select = {
    lookahead = true,
  },
  move = {
    set_jumps = true,
  },
}

local function setup_textobject_keymaps()
  local select = require('nvim-treesitter-textobjects.select')
  local move = require('nvim-treesitter-textobjects.move')
  local map = vim.keymap.set

  local function select_textobject(query)
    return function()
      select.select_textobject(query, 'textobjects')
    end
  end

  local function goto_next_start(query)
    return function()
      move.goto_next_start(query, 'textobjects')
    end
  end

  local function goto_next_end(query)
    return function()
      move.goto_next_end(query, 'textobjects')
    end
  end

  local function goto_previous_start(query)
    return function()
      move.goto_previous_start(query, 'textobjects')
    end
  end

  local function goto_previous_end(query)
    return function()
      move.goto_previous_end(query, 'textobjects')
    end
  end

  map({ 'x', 'o' }, 'ib', select_textobject('@block.inner'))
  map({ 'x', 'o' }, 'ab', select_textobject('@block.outer'))
  map({ 'x', 'o' }, 'ac', select_textobject('@class.outer'))
  map({ 'x', 'o' }, 'ic', select_textobject('@class.inner'))
  map({ 'x', 'o' }, 'aC', select_textobject('@comment.outer'))
  map({ 'x', 'o' }, 'ai', select_textobject('@conditional.outer'))
  map({ 'x', 'o' }, 'ii', select_textobject('@conditional.inner'))
  map({ 'x', 'o' }, 'af', select_textobject('@function.outer'))
  map({ 'x', 'o' }, 'if', select_textobject('@function.inner'))
  map({ 'x', 'o' }, 'al', select_textobject('@loop.outer'))
  map({ 'x', 'o' }, 'il', select_textobject('@loop.inner'))

  map({ 'n', 'x', 'o' }, ']f', goto_next_start('@function.outer'))
  map({ 'n', 'x', 'o' }, ']c', goto_next_start('@class.outer'))
  map({ 'n', 'x', 'o' }, ']F', goto_next_end('@function.outer'))
  map({ 'n', 'x', 'o' }, ']C', goto_next_end('@class.outer'))
  map({ 'n', 'x', 'o' }, '[f', goto_previous_start('@function.outer'))
  map({ 'n', 'x', 'o' }, '[c', goto_previous_start('@class.outer'))
  map({ 'n', 'x', 'o' }, '[F', goto_previous_end('@function.outer'))
  map({ 'n', 'x', 'o' }, '[C', goto_previous_end('@class.outer'))
end

local function setup_treesitter_filetypes()
  local group = vim.api.nvim_create_augroup('baggiponte-treesitter', { clear = true })

  vim.api.nvim_create_autocmd('FileType', {
    group = group,
    pattern = parsers,
    callback = function(args)
      pcall(vim.treesitter.start, args.buf)
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
  })
end

return {
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    dependencies = { 'hrsh7th/nvim-cmp' },
    config = function()
      require('nvim-autopairs').setup({})
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local cmp = require('cmp')
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    dependencies = {
      { 'kylechui/nvim-surround', opts = {} },
      { 'RRethy/nvim-treesitter-endwise' },
      { 'nvim-treesitter/nvim-treesitter-textobjects', branch = 'main' },
    },
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').setup()
      require('nvim-treesitter-textobjects').setup(textobjects)
      setup_textobject_keymaps()
      setup_treesitter_filetypes()
      vim.treesitter.language.register('bash', 'zsh')
    end,
  },
}
