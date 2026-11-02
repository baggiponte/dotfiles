local M = {}

---@alias EmptyString ''

---@return string
M.filepath = function()
  return vim.fn.expand('%:~:.')
end

---@return string|EmptyString
M.lsp_clients = function()
  local buf_clients = vim.lsp.get_clients()

  if vim.tbl_isempty(buf_clients) then
    return ''
  end

  local buf_client_names = {}
  for _, client in pairs(buf_clients) do
    table.insert(buf_client_names, client.name)
  end

  return ' ' .. table.concat(buf_client_names, '|')
end

return M
