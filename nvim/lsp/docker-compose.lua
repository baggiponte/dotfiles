local compose_files = {
  'compose.yaml',
  'compose.yml',
  'docker-compose.yaml',
  'docker-compose.yml',
}

---@type vim.lsp.Config
return {
  cmd = { 'bunx', '@microsoft/compose-language-service', '--stdio' },
  filetypes = { 'yaml' },
  -- Neovim has no compose filetype, and a compound one like
  -- `yaml.docker-compose` would stop the yaml LSPs and treesitter (which match
  -- filetypes exactly) from attaching. So match on the file name instead:
  -- not calling on_dir() skips this buffer.
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    if vim.list_contains(compose_files, vim.fs.basename(fname)) then
      on_dir(vim.fs.dirname(fname))
    end
  end,
}
