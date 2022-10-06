local null_ls = require('null-ls')

null_ls.setup({
  sources = {
    -- [[ python ]]
    null_ls.builtins.diagnostics.flake8.with({
      extra_args = {
        '--max-line-length=88',
        '--extend-ignore=E203',
        '--exclude',
        '.git/*',
        "--per-file-ignores='__init__.py:F401'",
      },
    }),
    -- null_ls.builtins.diagnostics.mypy,
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.isort.with({
      extra_args = { '--profile=black', '--filter-files' },
    }),
    -- [[ lua ]]
    null_ls.builtins.diagnostics.selene.with({
      extra_args = { '--config=' .. vim.fn.expand('$XDG_CONFIG_HOME/selene.toml') },
    }),
    null_ls.builtins.formatting.stylua,
    -- [[ yaml ]]
    null_ls.builtins.diagnostics.yamllint,
    null_ls.builtins.formatting.yamlfmt, -- requires go
    -- [[ json ]]
    null_ls.builtins.formatting.jq,
    -- [[ shell ]]
    null_ls.builtins.diagnostics.shellcheck.with({ filetypes = { 'sh', 'bash', 'zsh' } }),
    null_ls.builtins.formatting.shfmt.with({ filetypes = { 'sh', 'bash', 'zsh' } }), -- requires go
    null_ls.builtins.formatting.shellharden.with({ filetypes = { 'sh', 'bash', 'zsh' } }), -- requires rust
    -- [[ other ]]
    null_ls.builtins.hover.printenv,
  },
})
