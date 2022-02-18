# +---------------+
# | init binaries |
# +---------------+

[ -f "$CONFIG/broot/launcher/bash/br" ] && . "$CONFIG/broot/launcher/bash/br"

command -v jump > /dev/null && eval "$(jump shell zsh)"
command -v thefuck > /dev/null && eval "$(thefuck --alias)"

command -v pyenv > /dev/null && eval "$(pyenv init --path)" && eval "$(pyenv init -)"
command -v pyenv-virtualenv > /dev/null && eval "$(pyenv virtualenv-init -)"

