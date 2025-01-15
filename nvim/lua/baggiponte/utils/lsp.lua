local M = {}

M.on_attach = function(event, keymaps)
  local client = vim.lsp.get_client_by_id(event.data.client_id)
  if not client then
    return
  end

  for _, keymap in ipairs(keymaps) do
    vim.keymap.set(unpack(keymap))
  end

  -- Format the current buffer on save
  -- Don't do this for pyright/basedpyright, as I want to use ruff
  if client.supports_method('textDocument/formatting', event.buf) and not string.find(client.name, 'basedpyright') then
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
