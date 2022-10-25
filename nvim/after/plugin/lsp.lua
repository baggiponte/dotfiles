local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

local on_attach = function(_, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local bufmap = function(mode, shortcut, command)
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set(mode, shortcut, command, bufopts)
  end

  -- Mappings - See `:help vim.lsp.*`
  bufmap('n', 'F', vim.lsp.buf.format)
  bufmap('n', 'K', vim.lsp.buf.hover) -- Display hover information about the symbol
  bufmap('n', 'gh', vim.lsp.buf.signature_help) -- Display a function's signature information
  bufmap('n', 'gd', vim.lsp.buf.definition) -- Go to definition
  bufmap('n', 'gr', vim.lsp.buf.references) -- Lists all the references
  bufmap('n', '<leader>rn', vim.lsp.buf.rename) -- Rename all references of the symbol under the cursor
  bufmap('n', '<leader>ca', vim.lsp.buf.code_action) -- Selects a code action
end

local lspconfig = require('lspconfig')
local servers = {
  'bashls',
  'dockerls',
  'jsonls',
  'julials',
  'marksman',
  'pyright',
  'sqlls',
  'yamlls',
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup({ capabilities = capabilities, on_attach = on_attach })
end

lspconfig['sumneko_lua'].setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' }, -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
      diagnostics = { globals = { 'vim' } }, -- Get the language server to recognize the `vim` global
      workspace = { library = vim.api.nvim_get_runtime_file('', true) }, -- Make the server aware of Neovim runtime files
      telemetry = { enable = false }, -- Do not send telemetry data containing a randomized but unique identifier
    },
  },
})

lspconfig['arduino_language_server'].setup({
  on_attach = on_attach,
  capabilities = capabilities,
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
  filetypes = { 'arduino', 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
})

