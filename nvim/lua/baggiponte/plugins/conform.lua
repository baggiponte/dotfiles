local runner = require('baggiponte.lsp.runner')

local formatters_by_filetype = {
  lua = { 'stylua' },
  just = { 'just' },
  sh = { 'shfmt' },
  toml = { 'taplo' },
}

-- Declarative override per formatter. `runner` is a key in M.runners; `tool`
-- optionally overrides the binary (e.g. bunx needs the npm package name).
-- Formatters not listed here run through `mise`.
local formatter_overrides = {
  taplo = {
    runner = 'bunx',
    tool = '@taplo/cli',
    args = {
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
  },
}

return {
  'stevearc/conform.nvim',
  ft = {
    'lua',
    'just',
    'sh',
    'toml',
  },
  cmd = { 'ConformInfo' },
  ---@module "conform"
  ---@type conform.setupOpts
  opts = function()
    local formatters = {}

    for _, ft_formatters in pairs(formatters_by_filetype) do
      for _, name in ipairs(ft_formatters) do
        local ok, builtin = pcall(require, 'conform.formatters.' .. name)
        if not ok then
          return
        end

        local override = formatter_overrides[name]
        if override then
          -- Fully replace the built-in formatter with a declarative spec.
          local config = {
            command = runner.runners[override.runner].bin,
            args = function()
              local node = runner.prefix(override.runner)
              table.insert(node, override.tool or name)
              vim.list_extend(node, override.args)
              return node
            end,
          }
          formatters[name] = config
        else
          formatters[name] = runner.formatter(builtin, 'mise')
        end
      end
    end

    return {
      formatters_by_ft = formatters_by_filetype,
      formatters = formatters,
      format_on_save = { timeout_ms = 500, lsp_fallback = true },
    }
  end,
}
