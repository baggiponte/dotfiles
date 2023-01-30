local borders = require('baggiponte.utils.borders')

local sources_dap = {
  'python',
}

local sources_lsp = {
  'jsonls',
  'pyright',
  'sumneko_lua',
}

local sources_null_ls = {
  'actionlint',
  'black',
  'isort',
  'jq',
  'ruff',
  'selene',
  'shellcheck',
  'shfmt',
  'stylua',
  'yamlfmt',
  'yamllint',
}

return {
  {
    { 'smjonas/inc-rename.nvim', config = true },
    { 'williamboman/mason.nvim', cmd = 'Mason', opts = { ui = { border = borders } } },
    { 'jayp0521/mason-nvim-dap.nvim', cmd = 'Mason', opts = { ensure_installed = sources_dap } },
    { 'jayp0521/mason-null-ls.nvim', cmd = 'Mason', opts = { ensure_installed = sources_null_ls } },
    {
      'smjonas/inc-rename.nvim',
      name = 'inc-rename',
      cmd = 'IncRename',
      config = true,
    },
    {
      'neovim/nvim-lspconfig',
      dependencies = { 'williamboman/mason-lspconfig.nvim', opts = { ensure_installed = sources_lsp } },
      event = 'BufEnter',
      config = function()
        local lspconfig = require('lspconfig')

        local handlers = {
          ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = borders }),
          ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = borders }),
        }

        local capabilities = require('cmp_nvim_lsp').default_capabilities()

        require('lspconfig.ui.windows').default_options.border = borders

        local on_attach = function(_, bufnr)
          local bufmap = function(mode, shortcut, command, desc)
            local bufopts = { desc = desc, noremap = true, silent = true, buffer = bufnr }
            vim.keymap.set(mode, shortcut, command, bufopts)
          end

          bufmap('n', 'F', function()
            vim.lsp.buf.format({ async = true })
          end, '[f]ormat current buffer')

          vim.keymap.set('n', '<leader>rn', function()
            return ':IncRename ' .. vim.fn.expand('<cword>')
          end, { expr = true, desc = 'Incremental [r]e[n]ame of a symbol' })

          bufmap('n', 'K', vim.lsp.buf.hover, 'Display documentation on hover')
          bufmap('n', 'ca', vim.lsp.buf.code_action, 'Execute [c]ode [action]')
          bufmap('n', 'gD', vim.lsp.buf.declaration, '[g]o to [D]eclaration')
          bufmap('n', 'gd', vim.lsp.buf.definition, '[g]o to [d]efinition')
          bufmap('n', 'gh', vim.lsp.buf.signature_help, '[g]o to signature [h]elp')
          bufmap('n', 'gi', vim.lsp.buf.implementation, '[g]o to [i]mplementation')
          bufmap('n', 'gr', vim.lsp.buf.references, '[g]o to [r]eferences')
          bufmap('n', 'gt', vim.lsp.buf.type_definition, '[g]o to [t]ype definition')
        end

        local servers = {
          'jsonls',
          -- 'julials',
          'pyright',
          'ruff_lsp',
          -- 'yamlls',
        }

        for _, lsp in ipairs(servers) do
          lspconfig[lsp].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            handlers = handlers,
          })
        end

        lspconfig['sumneko_lua'].setup({
          on_attach = on_attach,
          capabilities = capabilities,
          handlers = handlers,
          settings = {
            Lua = {
              runtime = { version = 'LuaJIT' }, -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
              diagnostics = { globals = { 'vim' } }, -- Get the language server to recognize the `vim` global
              workspace = { library = vim.api.nvim_get_runtime_file('', true) }, -- Make the server aware of Neovim runtime files
              telemetry = { enable = false }, -- Do not send telemetry data containing a randomized but unique identifier
            },
          },
        })

        if vim.fn.executable('R') == 1 then
          lspconfig['r_language_server'].setup({
            on_attach = on_attach,
            capabilities = capabilities,
            handlers = handlers,
            filetypes = { 'r', 'rmd', 'quarto' },
          })
        end

        if vim.fn.executable('arduino-cli') then
          lspconfig['arduino_language_server'].setup({
            on_attach = on_attach,
            capabilities = capabilities,
            handlers = handlers,
            cmd = {
              'arduino-language-server',
              '-cli-config',
              vim.fn.expand('$XDG_CONFIG_HOME') .. '/arduino/arduino-cli.yaml',
              '-fqbn',
              'arduino:avr:uno',
              '-cli',
              'arduino-cli',
              '-clangd',
              vim.fn.stdpath('data') .. '/' .. 'mason/bin/clangd',
            },
          })

          lspconfig['clangd'].setup({
            on_attach = on_attach,
            capabilities = capabilities,
            handlers = handlers,
            filetypes = { 'arduino', 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
          })
        end
      end,
    },
  },
  {
    'jose-elias-alvarez/null-ls.nvim',
    event = 'BufEnter',
    dependencies = 'nvim-lua/plenary.nvim',
    config = function()
      local diagnostics = require('null-ls').builtins.diagnostics
      local formatting = require('null-ls').builtins.formatting

      -- local augroup = vim.api.nvim_create_augroup('LspFormatting', {})

      require('null-ls').setup({
        sources = {
          diagnostics.actionlint,
          -- diagnostics.cpplint.with({ filetypes = { 'arduino', 'c', 'cpp', 'cs', 'cuda' } }),
          diagnostics.ruff,
          diagnostics.mypy,
          diagnostics.selene.with({ extra_args = { '--config=' .. vim.fn.expand('$XDG_CONFIG_HOME/selene.toml') } }),
          diagnostics.shellcheck.with({ filetypes = { 'sh', 'bash', 'zsh' } }),
          diagnostics.yamllint,
          -- formatting.clang_format.with({ filetypes = { 'arduino', 'c', 'cpp', 'cs', 'cuda' } }),
          formatting.black,
          -- formatting.format_r.with({ filetypes = { 'r', 'rmd', 'quarto' } }),
          formatting.isort.with({ extra_args = { '--profile=black', '--filter-files' } }),
          formatting.jq,
          formatting.shfmt.with({ filetypes = { 'sh', 'bash', 'zsh' } }),
          -- formatting.styler.with({ filetypes = { 'r', 'rmd', 'quarto' } }),
          formatting.stylua,
          formatting.yamlfmt, -- only one that cannot be installed with brew, requires go + mason
        },
        -- on_attach = function(client, bufnr)
        --   if client.supports_method('textDocument/formatting') then
        --     vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
        --     vim.api.nvim_create_autocmd('BufWritePre', {
        --       group = augroup,
        --       buffer = bufnr,
        --       callback = function()
        --         vim.lsp.buf.format({ bufnr = bufnr })
        --       end,
        --     })
        --   end
        -- end,
      })
    end,
  },
}
