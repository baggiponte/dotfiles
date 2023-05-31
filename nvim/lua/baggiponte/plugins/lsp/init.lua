local borders = require('baggiponte.utils.borders')
local icons = require('baggiponte.utils.icons').icons
local mason = require('baggiponte.plugins.lsp.sources').mason

return {
  {
    'williamboman/mason.nvim',
    cmd = 'Mason',
    opts = {
      ui = {
        border = borders,
        icons = { package_installed = '✓', package_uninstalled = '✗', package_pending = '⟳' },
      },
    },
  },
  { 'jayp0521/mason-nvim-dap.nvim', cmd = 'Mason', opts = { ensure_installed = mason.dap } },
  { 'jayp0521/mason-null-ls.nvim', cmd = 'Mason', opts = { ensure_installed = mason.null_ls } },
  { 'smjonas/inc-rename.nvim', cmd = 'IncRename', config = true },
  {
    'glepnir/lspsaga.nvim',
    cmd = { 'Lspsaga' },
    dependencies = {
      { 'nvim-tree/nvim-web-devicons' },
      { 'nvim-treesitter/nvim-treesitter' }, -- install markdown and markdown_inline parser
    },
    opts = {
      lightbulb = { enable = false },
      symbol_in_winbar = { enable = false },
      beacon = { enable = false },
      ui = { border = 'rounded', code_action = icons.diagnostics.Hint },
    },
  },
  {
    'utilyre/barbecue.nvim',
    event = 'VeryLazy',
    name = 'barbecue',
    version = '*',
    dependencies = {
      'SmiteshP/nvim-navic',
      'nvim-tree/nvim-web-devicons', -- optional dependency
    },
    opts = {
      symbols = {
        separator = '',
      },
      exclude_filetypes = {
        'NvimTree',
        'TelescopePrompt',
        'Trouble',
        'fugitive',
        'git',
        'gitcommit',
        'help',
        'lazy',
        'lspinfo',
        'mason',
        'null-ls-info',
        'toggleterm',
      },
    },
  },
  {
    'jose-elias-alvarez/null-ls.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = 'nvim-lua/plenary.nvim',
    opts = function()
      local diagnostics = require('null-ls').builtins.diagnostics
      local formatting = require('null-ls').builtins.formatting

      local augroup = vim.api.nvim_create_augroup('LspFormatting', {})

      return {
        border = 'rounded',
        diagnostics_format = ' #{m} • #{s} [#{c}]',
        sources = {
          diagnostics.actionlint,
          diagnostics.cfn_lint,
          diagnostics.jsonlint,
          diagnostics.mypy,
          diagnostics.ruff,
          diagnostics.selene.with({ extra_args = { '--config=' .. vim.fn.expand('$XDG_CONFIG_HOME/selene.toml') } }),
          diagnostics.shellcheck.with({ filetypes = { 'sh', 'bash', 'zsh' } }),
          diagnostics.stylelint,
          diagnostics.terraform_validate,
          diagnostics.yamllint.with({ extra_args = { '-c=' .. vim.fn.expand('$XDG_CONFIG_HOME/yamllint/config') } }),
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
              'markdown',
              'markdown.mdx',
              'graphql',
              'handlebars',
            },
          }),
          formatting.terraform_fmt,
          formatting.yamlfmt, -- only one that cannot be installed with brew, requires go + mason
        },
        on_attach = function(client, bufnr)
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
        end,
      }
    end,
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason-lspconfig.nvim', opts = { ensure_installed = mason.lsp } },
      { 'b0o/SchemaStore.nvim', name = 'schemastore' },
    },
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local servers = require('baggiponte.plugins.lsp.sources').servers

      require('lspconfig.ui.windows').default_options.border = borders

      for lsp, lsp_specific_configs in pairs(servers) do
        local lsp_general_configs = {
          capabilities = require('baggiponte.plugins.lsp.utils').capabilities,
          on_attach = require('baggiponte.plugins.lsp.utils').on_attach,
          handlers = require('baggiponte.plugins.lsp.utils').handlers,
        }

        local lsp_configs = vim.tbl_deep_extend('force', lsp_general_configs, lsp_specific_configs)

        require('lspconfig')[lsp].setup(lsp_configs)
      end
    end,
  },
}
