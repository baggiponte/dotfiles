local noice_status, noice = pcall(require, 'noice')

if not noice_status then
  return
end

noice.setup({
  -- have messages (e.g. file saved) 
  messages = { enabled = false },
  presets = {
    inc_rename = true,
    command_palette = true,
  },
})
