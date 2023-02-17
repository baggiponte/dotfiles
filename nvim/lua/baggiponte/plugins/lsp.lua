local borders = require('baggiponte.utils.borders')
local icons = require('baggiponte.utils.icons').icons

local sources_dap = {
  'python',
}

local sources_lsp = {
  'lua_ls',
  'pyright',
  'ruff_lsp',
  'sourcery',
  -- 'arduino_language_server',
  -- 'docker-compose-language-server',
  -- 'dockerfile-language-server',
  -- 'jsonls',
  -- 'julials',
  -- 'yamlls',
}

local sources_null_ls = {
  'actionlint',
  'black',
  'isort',
  'jq',
  'ruff',
  'selene',
  'shellcheck',
  'shellharden',
  'shfmt',
  'stylua',
  'yamlfmt',
  'yamllint',
  -- 'semgrep',
  -- 'vulture',
}

return {
  {
    { 'williamboman/mason.nvim', cmd = 'Mason', opts = { ui = { border = borders } } },
    { 'jayp0521/mason-nvim-dap.nvim', cmd = 'Mason', opts = { ensure_installed = sources_dap } },
    { 'jayp0521/mason-null-ls.nvim', cmd = 'Mason', opts = { ensure_installed = sources_null_ls } },
    {
      'smjonas/inc-rename.nvim',
      cmd = 'IncRename',
      config = true,
    },
    {
      'glepnir/lspsaga.nvim',
      cmd = 'Lspsaga',
      event = 'VeryLazy',
      dependencies = { 'nvim-tree/nvim-web-devicons' },
      opts = {
        lightbulb = { enable = false },
        ui = { border = 'rounded', code_action = icons.diagnostics.Hint },
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
            -- diagnostics.semgrep,
            -- diagnostics.vulture,
            -- formatting.format_r.with({ filetypes = { 'r', 'rmd', 'quarto' } }),
            -- formatting.styler.with({ filetypes = { 'r', 'rmd', 'quarto' } }),
            diagnostics.actionlint,
            diagnostics.mypy,
            diagnostics.ruff,
            diagnostics.selene.with({ extra_args = { '--config=' .. vim.fn.expand('$XDG_CONFIG_HOME/selene.toml') } }),
            diagnostics.shellcheck.with({ filetypes = { 'sh', 'bash', 'zsh' } }),
            diagnostics.shellharden.with({ filetypes = { 'sh', 'bash', 'zsh' } }),
            diagnostics.yamllint,
            formatting.black,
            formatting.isort.with({ extra_args = { '--profile=black', '--filter-files' } }),
            formatting.jq,
            formatting.shfmt.with({ filetypes = { 'sh', 'bash', 'zsh' } }),
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
          local bufmap = function(shortcut, command, desc)
            local bufopts = { desc = desc, noremap = true, silent = true, buffer = bufnr }
            vim.keymap.set('n', shortcut, command, bufopts)
          end

          vim.keymap.set('n', '<leader>rn', function()
            return ':IncRename ' .. vim.fn.expand('<cword>')
          end, { expr = true, desc = 'Incremental [r]e[n]ame of a symbol' })

          bufmap('F', function()
            vim.lsp.buf.format({ async = true })
          end, '[f]ormat current buffer')

          bufmap('gf', '<cmd>Lspsaga lsp_finder<CR>', '[g]o [f]ind occurrences with Lspsaga')
          bufmap('gp', '<cmd>Lspsaga peek_definition<CR>', '[g]o [p]eek the definition with Lspsaga')
          bufmap('gD', vim.lsp.buf.declaration, '[g]o to [D]eclaration')
          bufmap('gd', vim.lsp.buf.definition, '[g]o to [d]efinition')
          bufmap('gh', vim.lsp.buf.signature_help, '[g]o to signature [h]elp')
          bufmap('gi', vim.lsp.buf.implementation, '[g]o to [i]mplementation')
          bufmap('gr', vim.lsp.buf.references, '[g]o to [r]eferences')
          bufmap('gt', vim.lsp.buf.type_definition, '[g]o to [t]ype definition')
          bufmap('K', vim.lsp.buf.hover, 'Display documentation on hover')
          bufmap('ca', vim.lsp.buf.code_action, 'Execute [c]ode [action]')
        end

        local servers = {
          'pyright',
          'ruff_lsp',
          'sourcery',
          -- 'docker-compose-language-server',
          -- 'dockerfile-language-server',
          -- 'jsonls',
          -- 'julials',
          -- 'yamlls',
        }

        for _, lsp in ipairs(servers) do
          lspconfig[lsp].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            handlers = handlers,
          })
        end

        lspconfig.rust_analyzer.setup({
          capabilities = capabilities,
          on_attach = on_attach,
          handlers = handlers,
          cmd = {
            'rustup',
            'run',
            'stable',
            'rust-analyzer',
          },
        })

        lspconfig['lua_ls'].setup({
          on_attach = on_attach,
          capabilities = capabilities,
          handlers = handlers,
          settings = {
            Lua = {
              runtime = { version = 'LuaJIT' }, -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
              diagnostics = { globals = { 'vim' } }, -- Get the language server to recognize the `vim` global
              workspace = { checkThirdParty = false },
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

        if vim.fn.executable('arduino-cli') == 1 then
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
}
