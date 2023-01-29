require('baggiponte.options')
require('baggiponte.autocmds')
require('baggiponte.keymaps')

require('baggiponte.packer')
require('impatient') -- MUST call impatient AFTER packer: startup time becomes 80ms vs 1.2s
require('impatient').enable_profile()
