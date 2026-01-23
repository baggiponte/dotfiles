# +------------+
# | Code tools |
# +------------+

alias amp="bunx @sourcegraph/amp"

# +---------+
# | Aliases |
# +---------+

# homebrew
alias b=brew
alias bi="b install"
alias bic="bi --cask"

alias bu="b uninstall"
alias buc="bu --cask"

alias gw="git worktree"

# +-----------+
# | Optionals |
# +-----------+

if hash colima 2>/dev/null; then
    alias c="colima"
fi

if hash minikube 2>/dev/null; then
    alias mk="minikube kubectl --"
fi

if hash kubectl 2>/dev/null; then
	alias k=kubectl
fi

if hash gh 2>/dev/null; then
	alias ghw='gh repo view --web'
fi

if hash lazygit 2>/dev/null; then
	alias lg=lazygit
fi

if hash gsed 2>/dev/null; then
	alias sed=gsed # gnu-sed (installed by homebrew)
fi

if hash gawk 2>/dev/null; then
	alias awk=gawk # gnu-awk (installed by homebrew)
fi

if hash gmake 2>/dev/null; then
	alias make=gmake # gnu-make (installed by homebrew)
fi

if [ -x "$(brew --prefix)/bin/gzip" ]; then
	alias zip=gzip
	alias gzip='$(brew --prefix)/bin/gzip'
fi

if hash eza 2>/dev/null; then
	alias l="eza --all --group-directories-first --icons --oneline --ignore-glob='.DS_Store|.*cache|__pycache__'"
	alias lig="ls --git-ignore"
	alias ll="l --long --git"
fi

if hash dust 2>/dev/null; then
	alias dust="dust --reverse"
fi
