#
# `eval` commands are run **after** compinit
#

# completions
command -v az /dev/null && eval "$(register-python-argcomplete az)"      # autocompletion for azure-cli
command -v cz >/dev/null && eval "$(register-python-argcomplete cz)"     # conventional commits + semver + keep a changelog
command -v pipx >/dev/null && eval "$(register-python-argcomplete pipx)" # autocompletion for pipx
command -v pixi >/dev/null && eval "$(pixi completion --shell zsh)"
command -v python >/dev/null && eval "$(python -m pip completion --zsh)" # autocompletion for pip
command -v rye >/dev/null && eval "$(rye self completion)"
command -v sk >/dev/null && compdef _gnu_generic sk

if command -v fzf >/dev/null; then
    eval "$(fzf --zsh)"
    compdef _gnu_generic fzf
fi


# +-------+
# | HOOKS |
# +-------+

# hook binaries into zsh
command -v direnv >/dev/null && eval "$(direnv hook zsh)"         # autoload dotenv files
command -v mise >/dev/null && eval "$(mise activate zsh)"         # hook mise
command -v zoxide >/dev/null && eval "$(zoxide init zsh --cmd=j)" # autojump with j

if command -v starship >/dev/null; then
	export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
	eval "$(starship init zsh)"
fi
