# Login shells only (new terminal windows, tmux panes, `zsh -l`), after
# /etc/zprofile. That file runs macOS path_helper, which puts /usr/bin & co.
# ahead of Homebrew and ~/.local/bin. Move our entries back to the front.
path=($zsh_path $path)
