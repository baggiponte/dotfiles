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

-- Running LSP work, keyed by client and token, fed by LspProgress.
-- statusline.nvim's lsp_progress component does the same once it replaces lualine.
local lsp_work = {} ---@type table<string, string>

vim.api.nvim_create_autocmd('LspProgress', {
  group = vim.api.nvim_create_augroup('baggiponte.lsp_progress', { clear = true }),
  ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
  callback = function(ev)
    local value = ev.data.params.value
    if type(value) ~= 'table' then
      return
    end
    local key = ev.data.client_id .. ':' .. tostring(ev.data.params.token)
    if value.kind == 'end' then
      lsp_work[key] = nil
    else
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      local pct = value.percentage and (' ' .. value.percentage .. '%%') or ''
      lsp_work[key] = ('%s: %s%s'):format(client and client.name or 'lsp', value.title or '', pct)
    end
    vim.cmd.redrawstatus()
  end,
})

---@return string|EmptyString
M.lsp_progress = function()
  local _, msg = next(lsp_work)
  return msg or ''
end

return M
