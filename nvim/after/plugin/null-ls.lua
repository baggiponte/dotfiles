local null_ls = require('null-ls')
local diagnostics = require('null-ls').builtins.diagnostics
local formatting = require('null-ls').builtins.formatting

null_ls.setup({
  sources = {
    diagnostics.flake8.with({ extra_args = { '--config=' .. vim.fn.expand('$XDG_CONFIG_HOME/.flake8') } }),
    diagnostics.selene.with({ extra_args = { '--config=' .. vim.fn.expand('$XDG_CONFIG_HOME/selene.toml') } }),
    diagnostics.shellcheck.with({ filetypes = { 'sh', 'bash', 'zsh' } }),
    diagnostics.yamllint,
    diagnostics.actionlint,
    formatting.black,
    formatting.isort.with({ extra_args = { '--profile=black', '--filter-files' } }),
    formatting.jq,
    formatting.shellharden.with({ filetypes = { 'sh', 'bash', 'zsh' } }),
    formatting.shfmt.with({ filetypes = { 'sh', 'bash', 'zsh' } }),
    formatting.stylua,
    formatting.yamlfmt,
  },
})
