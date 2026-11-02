local defer = require('baggiponte.defer')

-- Vimscript plugin: its plugin/ sets up the mappings and the rest is
-- autoloaded, but sourcing it still costs ~1ms, so keep lazy.nvim's VeryLazy.
defer.very_lazy(defer.loader({ 'vim-visual-multi' }))
