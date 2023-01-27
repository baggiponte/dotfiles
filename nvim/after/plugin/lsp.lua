local lspconfig = require('lspconfig')

local borders = require('baggiponte.utils.borders')

require('lspconfig.ui.windows').default_options.border = borders

local handlers = {
  ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = borders }),
  ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = borders }),
}

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local on_attach = function(_, bufnr)
  local bufmap = function(mode, shortcut, command, desc)
    local bufopts = { desc = desc, noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set(mode, shortcut, command, bufopts)
  end

  bufmap('n', '<space>f', function()
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
