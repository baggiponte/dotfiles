local M = {}

M.setup = function(server, config, capabilities)
  local handlers = {
    ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' }),
    ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' }),
  }

  local default_config = {
    capabilities = vim.deepcopy(capabilities),
    handlers = handlers,
  }

  local conf = vim.tbl_deep_extend('force', default_config, config or {})

  require('lspconfig')[server].setup(conf)
end

M.extend_capabilities = function(capabilities)
  local has_cmp, cmp = pcall(require, 'cmp_nvim_lsp')

  return vim.tbl_deep_extend(
    'force',
    {},
    vim.lsp.protocol.make_client_capabilities(),
    has_cmp and cmp.default_capabilities() or {},
    capabilities or {}
  )
end

M.on_attach = function(event, opts)
  local client = vim.lsp.get_client_by_id(event.data.client_id)
  if not client then
    return
  end

  for _, keymap in ipairs(opts.keymaps) do
    vim.keymap.set(unpack(keymap))
  end

  if client.name == 'ruff' then
    -- Disable hover in favor of Pyright
    client.server_capabilities.hoverProvider = false
  end

  -- Format the current buffer on save
  -- Don't do this for pyright/basedpyright, as I want to use ruff
  if client.supports_method('textDocument/formatting') and not string.find(client.name, 'basedpyright') then
    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = event.buf,
      callback = function()
        M._autoformat_and_organize_imports(client, event)
      end,
    })
  end
end

M._autoformat_and_organize_imports = function(client, event)
  -- if the client is ruff, then run the code action to organize imports
  -- (this is still not available as an LSP capability)
  if client.name == 'ruff' then
    vim.lsp.buf.code_action({
      apply = true,
      filter = function(action)
        return action.title == 'Ruff: Organize imports'
      end,
    })
  end

  vim.lsp.buf.format({ bufnr = event.buf, id = client.id })
end
return M
