local null_ls = require('null-ls')

null_ls.setup({
  sources = {
    -- linters
    null_ls.builtins.diagnostics.flake8.with({
      extra_args = {
        '--max-line-length=88',
        '--extend-ignore=E203',
        '--exclude',
        '.git/*',
        "--per-file-ignores='__init__.py:F401'",
      },
    }),
    null_ls.builtins.diagnostics.luacheck,
    -- null_ls.builtins.diagnostics.mypy, -- not using
    null_ls.builtins.diagnostics.shellcheck.with({ filetypes = { 'sh', 'bash', 'zsh' } }),
    null_ls.builtins.diagnostics.yamllint,
    -- formatters
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.jq,
    null_ls.builtins.formatting.isort.with({ extra_args = { '--profile=black', '--filter-files' } }),
    null_ls.builtins.formatting.markdownlint,
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.yamlfmt, -- requires go
    null_ls.builtins.formatting.shfmt.with({ filetypes = { 'sh', 'bash', 'zsh' } }), -- requires go
    null_ls.builtins.formatting.shellharden.with({ filetypes = { 'sh', 'bash', 'zsh' } }), -- requires rust
    -- hover actions
    null_ls.builtins.hover.printenv,
  },
})
