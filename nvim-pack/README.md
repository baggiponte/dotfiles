# Performance

Using the built-in [`vim.pack`](https://neovim.io/doc/user/pack.html#vim.pack) (Nvim 0.12+).
Run it side by side with the lazy.nvim config via `NVIM_APPNAME=nvim-pack nvim`.

## How loading works

- `lua/baggiponte/pack.lua` installs every plugin with `vim.pack.add()`; revisions are pinned in `nvim-pack-lock.json`.
- Plugins that are cheap or lazy by design are loaded at startup and configured eagerly.
- Plugins marked `data = OPT` stay off the runtimepath. `lua/baggiponte/defer.lua` packadds them on an event, filetype, key or command, standing in for lazy.nvim's `event`/`ft`/`keys`/`cmd`.
- Requiring a module of a not-yet-loaded `opt` plugin packadds it, like lazy.nvim's module loader.
- `vim.loader` and the disabled built-in plugins (netrw, matchit, ...) used to come from lazy.nvim's `performance` settings; they are now set by hand.
- Update plugins with `:lua vim.pack.update()`; build steps run from the `PackChanged` autocmd.

## Benchmarks

Run `scripts/bench.sh` (needs `hyperfine` and `tmux`). TUI runs happen inside a detached tmux session, so the times include tmux's own overhead (see the `-u NONE` row).

Results (Nvim 0.12.6, Apple Silicon, mean of 40+ runs; differences under ~3 ms are within run-to-run noise):

| Scenario | lazy.nvim | vim.pack |
|:---|---:|---:|
| headless `+qa` (clean: 20.7 ms) | 45.3 ± 4.1 ms | 44.5 ± 1.6 ms |
| headless, open a Python file | 76.5 ± 2.5 ms | 79.4 ± 5.7 ms |
| TUI `+qa` (clean: 58.0 ms) | 83.2 ± 2.5 ms | 86.1 ± 3.0 ms |
| TUI, open a Python file, wait for VeryLazy | 151.9 ± 5.0 ms | 144.7 ± 3.7 ms |

## Which plugins are lazy by design

Measured cost of sourcing `plugin/` plus `setup()` for each plugin, alone:

Loaded eagerly (lazy by design, or cheap):

- `gitsigns.nvim`: its `plugin/` already calls `setup()` and attaches to buffers lazily.
- `conform.nvim`, `nvim-lint`, `quicker.nvim`, `fff.nvim`, `mini.splitjoin`: under 1 ms; they only do work on write, read, quickfix or keypress.
- `vim-sayonara`, `vim-tmux-navigator`: Vimscript, `plugin/` only defines commands and mappings.
- `gruvbox-material`, `snacks.nvim`, `nvim-treesitter` (+ textobjects, endwise, surround): needed for the first screen anyway.

Deferred by hand (`opt`):

- Expensive `setup()` or `plugin/` (1.5 to 6 ms each): `blink.cmp`, `lualine.nvim`, `lsp_signature.nvim`, `nvim-dap-view`, `supermaven-nvim`, `nvim-highlight-colors`, `telescope.nvim`, `namu.nvim`, `symbol-usage.nvim`, `oil.nvim`, `lazydev.nvim`, `diffview.nvim`, `nvim-web-devicons`.
- Around 1 ms and only needed later: `noice.nvim`, `dressing.nvim`, `nvim-autopairs`, `vim-visual-multi`, `markview.nvim`, `refactoring.nvim`.
- Lazy by design but kept on `cmd` to save ~0.6 ms: `vim-dadbod`, `vim-dadbod-ui`, `vim-dadbod-completion`.
- Cheap, but `neo-tree.nvim` would hijack directory buffers at startup, so it loads on `:Neotree` or its key.
- Only used through their own keys or filetype: `neogit`, `neotest`, `nvim-dap` and their libraries (`plenary.nvim`, `nui.nvim`, `nvim-nio`).

## FAQ

### Compile from source

1. Install required dependencies:

```bash
brew install ninja cmake gettext curl
```

2. Clone the repository:

```bash
git clone https://github.com/neovim/neovim.git
```

3. Change directory to the repository:

```bash
cd neovim
```

4. Compile the source code:

```bash
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
```
