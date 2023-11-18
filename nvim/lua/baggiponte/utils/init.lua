local M = {}

---@param module string module to load
---@return table
M.import = function(module)
  local ok, result = pcall(require, module)
  if not ok then
    vim.notify('Failed to load module "' .. module .. '"', vim.log.levels.WARNING)
    error('Failed to load module "' .. module .. '"')
  end
  return result
end

return M
