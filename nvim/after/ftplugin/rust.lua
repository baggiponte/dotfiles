local bufnr = vim.api.nvim_get_current_buf()

vim.keymap.set(
  'n',
  '<leader>ca',
  -- supports rust-analyzer's grouping  or vim.lsp.buf.codeAction() if you don't want grouping.
  function()
    vim.cmd.RustLsp('codeAction')
  end,
  { silent = true, buffer = bufnr }
)
