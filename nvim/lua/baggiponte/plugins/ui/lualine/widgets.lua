local M = {}

---@alias EmptyString ''

---@return string
M.filepath = function()
  return vim.fn.expand('%:~:.')
end

---@return string|EmptyString
M.lsp_clients = function()
  local buf_clients = vim.lsp.get_active_clients()

  if vim.tbl_isempty(buf_clients) then
    return ''
  end

  local buf_client_names = {}
  for _, client in pairs(buf_clients) do
    if client.name ~= 'null-ls' and client.name ~= 'copilot' then
      table.insert(buf_client_names, client.name)
    end
  end

  return ' ' .. table.concat(buf_client_names, '|')
end

---@return string|EmptyString
M.null_ls_sources = function()
  local buf_clients = vim.lsp.get_active_clients({ name = 'null-ls' })

  if vim.tbl_isempty(buf_clients) then
    return ''
  end

  local null_ls_installed, null_ls = pcall(require, 'null-ls')

  if not null_ls_installed then
    return ''
  end

  local null_ls_sources_names = {}

  for _, source in ipairs(null_ls.get_source({ filetype = vim.bo.filetype })) do
    table.insert(null_ls_sources_names, source.name)
  end

  return '󰖷 ' .. table.concat(null_ls_sources_names, '|')
end

---@return string|EmptyString
M.copilot_active = function()
  local buf_clients = vim.lsp.get_active_clients({ name = 'copilot' })

  if vim.tbl_isempty(buf_clients) then
    return ''
  end

  return ' copilot'
end

return M
