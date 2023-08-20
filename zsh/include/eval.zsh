# `eval` commands are run **after** compinit
# completions
command -v cz >/dev/null && eval "$(register-python-argcomplete cz)"     # conventional commits + semver + keep a changelog
command -v pipx >/dev/null && eval "$(register-python-argcomplete pipx)" # autocompletion for pipx
command -v python >/dev/null && eval "$(python -m pip completion --zsh)" # autocompletion for pip
command -v pixi >/dev/null && eval "$(pixi completion --shell zsh)"

# +-------+
# | HOOKS |
# +-------+

# hook binaries into zsh
command -v direnv >/dev/null && eval "$(direnv hook zsh)"         # autoload dotenv files
command -v rtx >/dev/null && eval "$(rtx activate zsh)"           # hook rtx
command -v zoxide >/dev/null && eval "$(zoxide init zsh --cmd=j)" # autojump with j

if command -v starship >/dev/null; then
	export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
	eval "$(starship init zsh)"
fi
