require('baggiponte.packer') -- load plugins

-- MUST call impatient AFTER packer: startup time becomes 80ms vs 1.2s
require('impatient') -- impatient plugin to speedup startup
require('impatient').enable_profile() -- enable profiling with impatient

require('baggiponte.options') -- tweaking configurations (e.g. incremental search)
require('baggiponte.autocmds')
require('baggiponte.keymaps') -- keyboard remappings
