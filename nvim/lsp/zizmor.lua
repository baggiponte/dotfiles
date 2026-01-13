---@type vim.lsp.Config
return {
  cmd = { 'uvx', '--from=zizmor', '--', 'zizmor', '--lsp' },
  filetypes = { 'yaml' },
  -- Gate activation to .workflows/*.yaml; root_dir returning nil prevents attach.
  single_file_support = false,
  root_dir = function(fname)
    if not fname:match('/%.workflows/.*%.ya?ml$') then
      return nil
    end

    local git_root = vim.fs.find('.git', { path = fname, upward = true })[1]
    if git_root then
      return vim.fs.dirname(git_root)
    end

    return vim.fs.dirname(fname)
  end,
}
