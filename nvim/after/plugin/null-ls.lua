local null_ls = require('null-ls')

null_ls.setup({
  sources = {
    -- linters
    null_ls.builtins.diagnostics.flake8,
    null_ls.builtins.diagnostics.luacheck,
    -- null_ls.builtins.diagnostics.mypy, -- not using
    null_ls.builtins.diagnostics.shellcheck,
    null_ls.builtins.diagnostics.yamllint,
    -- formatters
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.jq,
    null_ls.builtins.formatting.isort,
    null_ls.builtins.formatting.markdownlint,
    -- null_ls.builtins.formatting.markdowntoc, -- not available with Mason
    null_ls.builtins.formatting.stylua,
    -- null_ls.builtins.formatting.yamlfmt, -- needs go
    -- hover actions
    null_ls.builtins.hover.printenv,
  },
})
