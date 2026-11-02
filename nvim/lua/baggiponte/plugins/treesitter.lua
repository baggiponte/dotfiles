local parsers = {
  'bash',
  'dockerfile',
  'gitattributes',
  'gitignore',
  'ini',
  'json',
  'just',
  'lua',
  'make',
  'markdown',
  'markdown_inline',
  'python',
  'regex',
  'requirements',
  'rust',
  'sql',
  'terraform',
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

  local function select_textobject(query)
    return function()
      select.select_textobject(query, 'textobjects')
    end
  end

  ---@param fn 'goto_next_start'|'goto_next_end'|'goto_previous_start'|'goto_previous_end'
  local function goto_textobject(fn, query)
    return function()
      move[fn](query, 'textobjects')
    end
  end

  for lhs, query in pairs({
    ib = '@block.inner',
    ab = '@block.outer',
    ac = '@class.outer',
    ic = '@class.inner',
    aC = '@comment.outer',
    ai = '@conditional.outer',
    ii = '@conditional.inner',
    af = '@function.outer',
    ['if'] = '@function.inner',
    al = '@loop.outer',
    il = '@loop.inner',
  }) do
    vim.keymap.set({ 'x', 'o' }, lhs, select_textobject(query))
  end

  for _, map in ipairs({
    { ']f', 'goto_next_start', '@function.outer' },
    { ']c', 'goto_next_start', '@class.outer' },
    { ']F', 'goto_next_end', '@function.outer' },
    { ']C', 'goto_next_end', '@class.outer' },
    { '[f', 'goto_previous_start', '@function.outer' },
    { '[c', 'goto_previous_start', '@class.outer' },
    { '[F', 'goto_previous_end', '@function.outer' },
    { '[C', 'goto_previous_end', '@class.outer' },
  }) do
    vim.keymap.set({ 'n', 'x', 'o' }, map[1], goto_textobject(map[2], map[3]))
  end
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

local defer = require('baggiponte.defer')

-- endwise compiles its query on every FileType (~3 ms on a Python buffer), but
-- only these languages ship endwise queries
defer.on_ft(
  { 'lua', 'luau', 'ruby', 'vim', 'sh', 'bash', 'zsh', 'elixir', 'julia', 'fish', 'verilog' },
  defer.loader({ 'nvim-treesitter-endwise' })
)

require('nvim-treesitter').setup()

-- install() is a no-op when everything is present, but still loads the
-- install machinery; only call it when a parser is actually missing.
local installed = {}
for _, path in ipairs(vim.api.nvim_get_runtime_file('parser/*.so', true)) do
  installed[vim.fn.fnamemodify(path, ':t:r')] = true
end
local missing = vim.tbl_filter(function(lang)
  return not installed[lang]
end, parsers)
if #missing > 0 then
  require('nvim-treesitter').install(missing)
end
require('nvim-treesitter-textobjects').setup(textobjects)
setup_textobject_keymaps()
setup_treesitter_filetypes()
vim.treesitter.language.register('bash', 'zsh')
