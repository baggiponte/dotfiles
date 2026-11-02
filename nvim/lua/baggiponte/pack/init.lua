-- Plugins are pinned in nvim-pack-lock.json. vim.pack has no lazy-loading:
-- plugins that are cheap or lazy by design load at startup, and those marked
-- `opt` stay off the runtimepath until baggiponte.defer packadds them.

local function gh(repo)
  return 'https://github.com/' .. repo
end

-- Build steps. Defined before vim.pack.add() so they also run on the very
-- first install.
vim.api.nvim_create_autocmd('PackChanged', {
  group = vim.api.nvim_create_augroup('baggiponte-pack-hooks', { clear = true }),
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if kind ~= 'install' and kind ~= 'update' then
      return
    end

    if name == 'telescope-fzf-native.nvim' then
      vim.system({ 'make' }, { cwd = ev.data.path }):wait()
    elseif name == 'fff.nvim' then
      if not ev.data.active then
        vim.cmd.packadd(name)
      end
      require('fff.download').download_or_build_binary()
    elseif name == 'nvim-treesitter' and kind == 'update' then
      if not ev.data.active then
        vim.cmd.packadd(name)
      end
      vim.cmd('TSUpdate')
    end
  end,
})

local OPT = { opt = true }

-- Paths of the `opt` plugins, by name, filled in by `load` below for
-- defer.load_on_require(). It can't call vim.pack.get() instead: that waits
-- on async work, which is not allowed in every context (E565 from the
-- statusline).
local opt_paths = {} ---@type table<string, string>

vim.pack.add({
  -- UI
  gh('sainnhe/gruvbox-material'),
  -- cmdline popup, statusline, vim.ui.select/input, notifier, indent guides
  gh('baggiponte/neat.nvim'),
  -- neat's cmdline needs nui on the runtimepath when its popup opens (from a
  -- UI event, where :packadd is not allowed). It has no plugin/, so it is free.
  gh('MunifTanjim/nui.nvim'),
  { src = gh('brenoprata10/nvim-highlight-colors'), data = OPT },

  -- libraries
  { src = gh('nvim-lua/plenary.nvim'), data = OPT },
  { src = gh('nvim-tree/nvim-web-devicons'), data = OPT },
  { src = gh('nvim-neotest/nvim-nio'), data = OPT },

  -- treesitter
  { src = gh('nvim-treesitter/nvim-treesitter'), version = 'main' },
  { src = gh('nvim-treesitter/nvim-treesitter-textobjects'), version = 'main' },
  { src = gh('RRethy/nvim-treesitter-endwise'), data = OPT },
  { src = gh('kylechui/nvim-surround'), data = OPT },
  { src = gh('windwp/nvim-autopairs'), data = OPT },

  -- editing
  { src = gh('saghen/blink.cmp'), version = vim.version.range('*'), data = OPT },
  { src = gh('supermaven-inc/supermaven-nvim'), data = OPT },
  { src = gh('ray-x/lsp_signature.nvim'), data = OPT },
  { src = gh('folke/lazydev.nvim'), data = OPT },
  gh('stevearc/conform.nvim'),
  gh('mfussenegger/nvim-lint'),
  gh('echasnovski/mini.splitjoin'),
  { src = gh('ThePrimeagen/refactoring.nvim'), data = OPT },
  { src = gh('mg979/vim-visual-multi'), data = OPT },
  { src = gh('Wansmer/symbol-usage.nvim'), data = OPT },

  -- navigation
  { src = gh('dmtrKovalenko/fff.nvim'), data = OPT },
  { src = gh('nvim-telescope/telescope.nvim'), data = OPT },
  { src = gh('nvim-telescope/telescope-fzf-native.nvim'), data = OPT },
  { src = gh('bassamsdata/namu.nvim'), data = OPT },
  { src = gh('stevearc/oil.nvim'), data = OPT },
  { src = gh('nvim-neo-tree/neo-tree.nvim'), version = 'v3.x', data = OPT },
  gh('stevearc/quicker.nvim'),
  gh('mhinz/vim-sayonara'),

  -- git
  gh('lewis6991/gitsigns.nvim'),
  { src = gh('NeogitOrg/neogit'), data = OPT },
  { src = gh('sindrets/diffview.nvim'), data = OPT },

  -- languages and tools
  { src = gh('OXY2DEV/markview.nvim'), data = OPT },
  { src = gh('tpope/vim-dadbod'), data = OPT },
  { src = gh('kristijanhusak/vim-dadbod-completion'), data = OPT },
  { src = gh('kristijanhusak/vim-dadbod-ui'), data = OPT },
  { src = gh('mfussenegger/nvim-dap'), data = OPT },
  { src = gh('igorlfs/nvim-dap-view'), data = OPT },
  { src = gh('mfussenegger/nvim-dap-python'), data = OPT },
  { src = gh('theHamsta/nvim-dap-virtual-text'), data = OPT },
  { src = gh('nvim-neotest/neotest'), data = OPT },
  { src = gh('nvim-neotest/neotest-python'), data = OPT },
}, {
  confirm = false,
  load = function(plugin)
    if plugin.spec.data and plugin.spec.data.opt then
      opt_paths[plugin.spec.name] = plugin.path
    else
      vim.cmd.packadd({ plugin.spec.name, bang = true })
    end
  end,
})

require('baggiponte.defer').load_on_require(opt_paths)

-- Local, unmanaged plugin.
local rex = vim.fn.expand('~/dev/projs/rex-navigator.nvim')
if vim.uv.fs_stat(rex) then
  vim.opt.rtp:append(rex)
end

require('baggiponte.pack.commands')
