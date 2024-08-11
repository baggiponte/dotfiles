# +---------+
# | Aliases |
# +---------+

# utilities
alias ...="../../"
alias text="open -a TextEdit"

# homebrew
alias b=brew
alias bi="b install"
alias bic="bi --cask"

alias bu="b uninstall"
alias buc="bu --cask"

alias bl="b list"
alias blf="bl --formula"
alias blc="bl --cask"

alias bd="b doctor"

alias td="date +%Y-%m-%d"

# +-----------+
# | Optionals |
# +-----------+

# don't need to set this if quarto is installed using rundel's tap
# if [ -x /Applications/quarto/bin/quarto ]; then
# 	alias quarto=/Applications/quarto/bin/quarto
# fi

if hash colima 2>/dev/null; then
    alias c="colima"
fi

if hash gh 2>/dev/null; then
	alias ghw='gh repo view --web'
fi

if hash lazygit 2>/dev/null; then
	alias lg=lazygit
fi

if hash zellij 2>/dev/null; then
	alias z=zellij
fi

if hash jupyter-lab 2>/dev/null; then
	alias jl=jupyter-lab
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

if hash arduino-cli 2>/dev/null; then
	alias ar=arduino-cli
fi
