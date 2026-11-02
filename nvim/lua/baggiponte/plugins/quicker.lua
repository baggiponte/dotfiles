---@module "quicker"
---@type quicker.SetupOptions
local opts = {}

-- Cheap enough to set up eagerly: it only acts on quickfix buffers.
require('quicker').setup(opts)
