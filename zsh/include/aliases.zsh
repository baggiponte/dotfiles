# +------------+
# | Code tools |
# +------------+

alias o="opencode --auto"

# +---------+
# | Aliases |
# +---------+

# homebrew
alias b=brew
alias bi="b install"
alias bic="bi --cask"

alias bu="b uninstall"
alias buc="bu --cask"

alias ...="cd ../.."

# +-----------+
# | Optionals |
# +-----------+
# $+commands[x] is 1 when x is on PATH (a hash lookup, no subprocess).

(( $+commands[colima] ))  && alias c=colima
(( $+commands[kubectl] )) && alias k=kubectl
(( $+commands[gh] ))      && alias ghw='gh repo view --web'
(( $+commands[lazygit] )) && alias lg=lazygit
(( $+commands[gsed] ))    && alias sed=gsed   # gnu-sed (installed by homebrew)
(( $+commands[gawk] ))    && alias awk=gawk   # gnu-awk (installed by homebrew)
(( $+commands[gmake] ))   && alias make=gmake # gnu-make (installed by homebrew)
(( $+commands[eza] ))     && alias l="eza --all --group-directories-first --icons --oneline --ignore-glob='.DS_Store|.*cache|__pycache__'"
