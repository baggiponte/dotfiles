local safe_require = require('baggiponte.utils').safe_require

local augroup = vim.api.nvim_create_augroup('LspFormatting', {})

local on_attach = function(client, bufnr)
  if client.supports_method('textDocument/formatting') then
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = augroup,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({ bufnr = bufnr })
      end,
    })
  end
end

return {
  'nvimtools/none-ls.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = 'nvim-lua/plenary.nvim',
  opts = function()
    local diagnostics = safe_require('null-ls').builtins.diagnostics
    local formatting = safe_require('null-ls').builtins.formatting

    return {
      border = 'rounded',
      diagnostics_format = ' #{m} • #{s} [#{c}]',
      sources = {
        diagnostics.actionlint,
        diagnostics.jsonlint,
        diagnostics.mypy.with({ only_local = '.venv/bin/' }),
        diagnostics.ruff,
        diagnostics.selene.with({ extra_args = { '--config=' .. vim.fn.expand('$XDG_CONFIG_HOME/selene.toml') } }),
        diagnostics.shellcheck.with({ filetypes = { 'sh', 'bash', 'zsh' } }),
        diagnostics.terraform_validate,
        -- diagnostics.tfsec,
        diagnostics.yamllint.with({ extra_args = { '-c=' .. vim.fn.expand('$XDG_CONFIG_HOME/yamllint/config') } }),
        -- diagnostics.stylelint, -- css
        formatting.black,
        formatting.isort.with({ extra_args = { '--profile=black', '--filter-files' } }),
        formatting.jq,
        formatting.shfmt.with({ filetypes = { 'sh', 'bash', 'zsh' } }),
        formatting.stylua,
        formatting.prettierd.with({
          filetypes = {
            'javascript',
            'javascriptreact',
            'typescript',
            'typescriptreact',
            'vue',
            'css',
            'scss',
            'less',
            'html',
            -- 'json',
            -- 'jsonc',
            -- 'yaml',
            -- 'markdown',
            -- 'markdown.mdx',
          },
        }),
        formatting.terraform_fmt,
      },
      on_attach = on_attach,
    }
  end,
}
