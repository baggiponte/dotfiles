# History settings are in /etc/zshrc file, read at startup.

##### Source at startup #####
for FILE in $ZDOTDIR/*.zsh; do
    # `.` executes the code it reads from a file
    . $FILE
done

##### broot #####
[ -f "$CONFIG/broot/launcher/bash/br" ] && . "$CONFIG/broot/launcher/bash/br"

##### brew autocompletion #####
# see https://docs.brew.sh/Shell-Completion 
if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

##### Terminal prompt #####
eval "$(starship init zsh)" # starship is managed in $HOME/.config/starship.toml

##### zoxide | alternative to cd #####
eval "$(zoxide init zsh)"

##### export my scripts to $PATH #####
export PATH="$MYBINS:$PATH"

##### Pyenv #####
eval "$(pyenv init -)"

##### pyenv-virtualenv #####
eval "$(pyenv virtualenv-init -)"

##### Conda #####
__conda_setup="$('$CONDA_ROOT/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$CONDA_ROOT/etc/profile.d/conda.sh" ]; then
        . "$CONDA_ROOT/etc/profile.d/conda.sh" 
    else
        export PATH="$CONDA_ROOT/bin:$PATH"
    fi
fi
unset __conda_setup

##### Zsh Autocompletion #####

# # for pipx
# autoload -U bashcompinit
# bashcompinit
# eval "$(register-python-argcomplete pipx)"

# Basic auto/tab complete:
autoload -U compinit


zstyle ':completion:*' menu select

# Auto complete with case insenstivity
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

