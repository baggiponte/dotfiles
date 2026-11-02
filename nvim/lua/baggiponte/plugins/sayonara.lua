-- Vimscript plugin: plugin/ only defines the command

-- vim-sayonara asks about unsaved changes with `echo` + `getchar()`, which
-- never reaches the UI as a prompt, so neat's confirm popup can't show it and
-- it lands on the cmdline. Ask with confirm() instead (neat draws that one),
-- then answer sayonara's own prompt for it.
---@param bang boolean
local function sayonara(bang)
  local cmd = bang and 'Sayonara!' or 'Sayonara'
  if not vim.bo.modified then
    return vim.cmd(cmd)
  end
  local choice = vim.fn.confirm('Unsaved changes', '&Write\n&Skip\n&Break', 3)
  if choice == 1 then
    -- write here rather than through sayonara so E32 (no file name) and
    -- friends surface as normal errors instead of being swallowed
    vim.cmd.write()
  elseif choice == 2 then
    -- typeahead is what getchar() reads first, so sayonara takes this 's'
    -- as the answer to its prompt without waiting for a key; :silent keeps
    -- its echoed prompt from being left behind on the cmdline
    vim.api.nvim_feedkeys('s', 'ni', false)
    cmd = 'silent ' .. cmd
  else
    return
  end
  vim.cmd(cmd)
end

require('baggiponte.defer').keys({
  {
    'q',
    function()
      sayonara(false)
    end,
    mode = { 'n', 'v' },
    desc = 'Sayonara: quit current buffer',
  },
  {
    'Q',
    function()
      sayonara(true)
    end,
    mode = { 'n', 'v' },
    desc = 'Sayonara: force quit current buffer',
  },
})
