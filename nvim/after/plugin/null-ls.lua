local null_ls = require('null-ls')

null_ls.setup({
  sources = {
    -- linters
    null_ls.builtins.diagnostics.flake8,
    null_ls.builtins.diagnostics.luacheck,
    -- null_ls.builtins.diagnostics.mypy, -- not using
    null_ls.builtins.diagnostics.shellcheck.with({ filetypes = { 'sh', 'bash', 'zsh' } }),
    null_ls.builtins.diagnostics.yamllint,
    -- formatters
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.jq,
    null_ls.builtins.formatting.isort,
    null_ls.builtins.formatting.markdownlint,
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.yamlfmt, -- needs go
    null_ls.builtins.formatting.shfmt.with({ filetypes = { 'sh', 'bash', 'zsh' } }), -- needs go
    null_ls.builtins.formatting.shellharden.with({ filetypes = { 'sh', 'bash', 'zsh' } }), -- needs rust
    -- hover actions
    null_ls.builtins.hover.printenv,
  },
})
