local null_ls = require('null-ls')
local diagnostics = require('null-ls').builtins.diagnostics
local formatting = require('null-ls').builtins.formatting

null_ls.setup({
  sources = {
    diagnostics.cpplint.with({ filetypes = { 'arduino', 'c', 'cpp', 'cs', 'cuda' } }),
    diagnostics.flake8.with({ extra_args = { '--config=' .. vim.fn.expand('$XDG_CONFIG_HOME/.flake8') } }),
    diagnostics.selene.with({ extra_args = { '--config=' .. vim.fn.expand('$XDG_CONFIG_HOME/selene.toml') } }),
    diagnostics.shellcheck.with({ filetypes = { 'sh', 'bash', 'zsh' } }),
    diagnostics.yamllint,
    diagnostics.actionlint,
    -- is it builtin clangd server?
    -- formatting.clang_format.with({ filetypes = { 'arduino', 'c', 'cpp', 'cs', 'cuda' } }),
    formatting.black,
    formatting.isort.with({ extra_args = { '--profile=black', '--filter-files' } }),
    formatting.jq,
    formatting.shellharden.with({ filetypes = { 'sh', 'bash', 'zsh' } }),
    formatting.shfmt.with({ filetypes = { 'sh', 'bash', 'zsh' } }),
    formatting.stylua,
    formatting.yamlfmt, -- only one that cannot be installed with brew, requires go + mason
  },
})
