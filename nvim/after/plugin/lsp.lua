local lspconfig = require('lspconfig')
local saga = require('lspsaga')

saga.init_lsp_saga({
  code_action_lightbulb = { enable = false }, -- it's heinous
  border_style = 'rounded',
  move_in_saga = { prev = '<C-k>', next = '<C-j>' },
  code_action_icon = '',
  definition_action_keys = {
    edit = '<CR>',
    vsplit = 'V',
  },
})

local on_attach = function(_, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local bufmap = function(mode, shortcut, command)
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set(mode, shortcut, command, bufopts)
  end

  -- Mappings - See `:help vim.lsp.*`
  bufmap('n', 'F', vim.lsp.buf.format)
  bufmap('n', 'gh', vim.lsp.buf.signature_help) -- Display a function's signature information

  -- find references and defintions
  bufmap('n', 'gf', function()
    vim.cmd('Lspsaga lsp_finder')
  end)

  -- hover documentation
  bufmap('n', 'K', function()
    vim.cmd('Lspsaga hover_doc')
  end) -- Display hover information about the symbol

  -- peek definition
  bufmap('n', 'gp', function()
    vim.cmd('Lspsaga peek_definition')
  end)

  -- Go to definition
  bufmap('n', 'gd', function()
    vim.cmd('Telescope lsp_definitions')
  end)

  -- Lists all the references
  bufmap('n', 'gr', function()
    vim.cmd('Telescope lsp_references')
  end)

  -- Lists all the implementations
  bufmap('n', 'gi', function()
    vim.cmd('Telescope lsp_implementations')
  end)

  -- go to type declaration
  bufmap('n', 'gt', function()
    vim.cmd('Telescope lsp_type_definitions')
  end)

  -- Selects a code action
  bufmap('n', 'ca', vim.lsp.buf.code_action)

  -- Rename all references of the symbol under the cursor
  vim.keymap.set('n', '<leader>rn', function()
    return ':IncRename ' .. vim.fn.expand('<cword>')
  end, { expr = true })
end

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

local servers = {
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

lspconfig['r_language_server'].setup({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { 'r', 'rmd', 'quarto' },
})

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
