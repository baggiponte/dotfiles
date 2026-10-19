-- Tmux-style bindings live separately; keep other Rex configuration here.
require("tmux")
dofile(os.getenv("HOME") .. "/dev/projs/rex-navigator.nvim/rex/navigator.lua").setup()
