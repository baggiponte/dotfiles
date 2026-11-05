local runner = require('baggiponte.runner')

local formatters_by_ft = {
  just = { 'just' },
  lua = { 'stylua' },
  python = { 'ruff_organize_imports', 'ruff_format' },
  sh = { 'shfmt' },
  toml = { 'taplo' },
}

-- Formatters run through a runtime manager rather than whatever is on PATH
-- (uvx first, then mise, then bunx; see AGENTS.md). Unlisted ones use mise.
local runner_by_formatter = {
  ruff_format = 'uvx',
  ruff_organize_imports = 'uvx',
}

-- taplo is only published to npm as @taplo/cli, and its defaults collapse
-- arrays and inline tables, so it gets a full spec instead of the built-in.
local taplo = {
  command = 'bunx',
  args = {
    '--yes',
    '@taplo/cli',
    'format',
    '--option',
    'compact_arrays=false',
    '--option',
    'compact_inline_tables=false',
    '--option',
    'array_auto_collapse=false',
    '--option',
    'array_auto_expand=false',
    '--stdin-filepath',
    '$FILENAME',
    '-',
  },
}

-- Cheap enough to set up eagerly: conform only does work on BufWritePre.
do
  local formatters = { taplo = taplo }

  for _, names in pairs(formatters_by_ft) do
    for _, name in ipairs(names) do
      local ok, builtin = pcall(require, 'conform.formatters.' .. name)
      if ok and not formatters[name] then
        formatters[name] = runner.formatter(builtin, runner_by_formatter[name] or 'mise')
      end
    end
  end

  require('conform').setup({
    formatters_by_ft = formatters_by_ft,
    formatters = formatters,
    format_on_save = function(bufnr)
      if not vim.g.disable_autoformat and not vim.b[bufnr].disable_autoformat then
        return { timeout_ms = 500, lsp_format = 'fallback' }
      end
    end,
  })
end

-- Save an agent's file without reformatting lines it didn't touch. Also turns
-- off the trailing-whitespace strip (autocmds.lua).
vim.api.nvim_create_user_command('FormatToggle', function(args)
  local scope = args.bang and vim.g or vim.b
  scope.disable_autoformat = not scope.disable_autoformat
  vim.notify(
    ('Format on save %s %s'):format(
      scope.disable_autoformat and 'off' or 'on',
      args.bang and 'everywhere' or 'for this buffer'
    )
  )
end, { bang = true, desc = 'Toggle format on save for this buffer (! for every buffer)' })
