local M = {}

M.mason_packages_root = vim.fn.stdpath('data') .. '/mason/packages'

M.mason_has = function(name)
  return vim.uv.fs_stat(M.mason_packages_root .. '/' .. name)
end

M.mason_get_path = function(name)
  return M.mason_packages_root .. '/' .. name
end

return M
