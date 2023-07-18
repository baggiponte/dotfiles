local borders = require('baggiponte.utils.borders')
local mason = require('baggiponte.plugins.lsp.sources').mason
local utils = require('baggiponte.plugins.lsp.utils')

return {
  {
    'williamboman/mason.nvim',
    build = ':MasonUpdate',
    cmd = { 'Mason' },
    opts = {
      -- PATH = 'append',
      ui = {
        border = borders,
        icons = { package_installed = '✓', package_uninstalled = '✗', package_pending = '⟳' },
      },
    },
  },
  {
    'jayp0521/mason-nvim-dap.nvim',
    cmd = { 'Mason', 'DapInstall', 'DapUninstall' },
    opts = { ensure_installed = mason.dap },
  },
  {
    'jayp0521/mason-null-ls.nvim',
    cmd = { 'Mason', 'NullLsInstall', 'NullLsUninstall' },
    opts = { ensure_installed = mason.null_ls },
  },
  { 'smjonas/inc-rename.nvim', cmd = { 'IncRename' }, config = true },
  {
    'jose-elias-alvarez/null-ls.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = 'nvim-lua/plenary.nvim',
    opts = function()
      local diagnostics = require('null-ls').builtins.diagnostics
      local formatting = require('null-ls').builtins.formatting

      return {
        border = 'rounded',
        diagnostics_format = ' #{m} • #{s} [#{c}]',
        sources = {
          diagnostics.actionlint,
          diagnostics.jsonlint,
          diagnostics.mypy,
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
        on_attach = utils.nullls_on_attach,
      }
    end,
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason-lspconfig.nvim', opts = { ensure_installed = mason.lsp } },
      -- { 'b0o/SchemaStore.nvim', name = 'schemastore' },
    },
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local servers = require('baggiponte.plugins.lsp.sources').servers

      require('lspconfig.ui.windows').default_options.border = borders

      for lsp, lsp_specific_configs in pairs(servers) do
        local lsp_general_configs = {
          capabilities = utils.capabilities,
          on_attach = utils.lsp_on_attach,
          handlers = utils.handlers,
        }

        local lsp_configs = vim.tbl_deep_extend('force', lsp_general_configs, lsp_specific_configs)

        require('lspconfig')[lsp].setup(lsp_configs)
      end
    end,
  },
}
