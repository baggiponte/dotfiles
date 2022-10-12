# +------------------+
# | ENV VARS CONFIGS |
# +------------------+

if hash nvim 2>/dev/null; then
	# NOTE: exporting EDITOR=nvim will automatically run bindkey -v
	# e.g. zsh will use vim keybindings!
	export EDITOR="nvim"
	export MANPAGER="nvim +Man!"
	export MYVIMRC="$XDG_CONFIG_HOME/nvim/init.lua"
fi

if hash npm 2>/dev/null; then
	export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/.npmrc"
	export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"
fi

if hash pipx 2>/dev/null; then
	export PIPX_HOME="$HOME/.local/pipx"
	export PIPX_BIN_DIR="$HOME/.local/bin"
fi

if hash pyenv 2>/dev/null; then
	export PYENV_ROOT="$HOME/.pyenv"
fi

if hash cookiecutter 2>/dev/null; then
	export COOKIECUTTER_CONFIG="$XDG_CONFIG_HOME/cookiecutter.yaml"
fi

if hash psql 2>/dev/null; then
	export PGDATA="/usr/local/var/postgres@14"
	export PGDATABASE="postgres"
fi
