local M = {}

---@param module string module to load
---@return table|nil
M.safe_require = function(module)
  local ok, result = pcall(require, module)
  if not ok then
    vim.notify('Failed to load module "' .. module .. '"', vim.log.levels.WARNING)
    return nil
  end
  return result
end

return M
