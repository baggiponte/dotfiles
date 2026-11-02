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
    format_on_save = { timeout_ms = 500, lsp_format = 'fallback' },
  })
end
