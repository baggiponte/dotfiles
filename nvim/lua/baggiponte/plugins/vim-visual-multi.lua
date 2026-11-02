local defer = require('baggiponte.defer')

-- Its plugin/ only sets up the mappings, but sourcing it still costs ~1 ms,
-- so it loads after the first screen is drawn.
defer.very_lazy(defer.loader({ 'vim-visual-multi' }))
