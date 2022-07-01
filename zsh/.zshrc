# +-------------------------------------------------------------------------+
# | REFERENCES                                                              |
# | * https://scriptingosx.com/2019/06/moving-to-zsh-part-3-shell-options/  |
# | * https://linux.die.net/man/1/zshoptions                                |
# | * https://thevaluable.dev/zsh-completion-guide-examples/                |
# +-------------------------------------------------------------------------+

# +-----------------------+
# | ALIASES AND FUNCTIONS |
# +-----------------------+

source $ZDOTDIR/aliases.zsh

# +-------+
# | BROOT |
# +-------+

source /Users/luca/Library/Application\ Support/org.dystroy.broot/launcher/bash/br

# +-----+
# | PDM |
# +-----+

if [ -n "$PYTHONPATH" ]; then
    export PYTHONPATH="$PIPX_HOME/venvs/pdm/lib/python3.10/site-packages/pdm/pep582":$PYTHONPATH
else
    export PYTHONPATH="$PIPX_HOME/venvs/pdm/lib/python3.10/site-packages/pdm/pep582"
fi

# # +---------------+
# # | CONDA & MAMBA |
# # +---------------+
# 
# _CONDA_INIT_DIR="$(brew --caskroom)/miniconda/base"
# 
# # the following lines are managed by conda: do not edit!
# __conda_setup="$("$_CONDA_INIT_DIR/bin/conda" 'shell.zsh' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "$_CONDA_INIT_DIR/etc/profile.d/conda.sh" ]; then
#         . "$_CONDA_INIT_DIR/etc/profile.d/conda.sh"
#     else
#         export PATH="$_CONDA_INIT_DIR/bin:$PATH"
#     fi
# fi
# unset __conda_setup
# 
# # setup mamba
# if [ -f "$_CONDA_INIT_DIR/etc/profile.d/mamba.sh" ]; then
#     . "$_CONDA_INIT_DIR/etc/profile.d/mamba.sh"
# fi
 
# +-------------+
# | ZSH SETOPTS |
# +-------------+

setopt complete_in_word         # tab completion works from both sides
setopt extended_glob            # use extended globbing syntax.
setopt no_case_glob             # case insentive globbing
setopt glob_dots                # match dotfiles without specifying the dot

# setopt auto_cd                  # go to folder path without using cd.

setopt auto_pushd               # push the old directory onto the stack on cd.
setopt pushd_ignore_dups        # do not store duplicates in the stack.
setopt pushd_silent             # do not print the directory stack after pushd or popd.

# setopt correct                  # spelling correction
setopt cdable_vars              # change directory to a path stored in a variable.

setopt extended_history         # write the history file in the ':start:elapsed;command' format.
setopt share_history            # share history between all sessions.
setopt hist_expire_dups_first   # expire a duplicate event first when trimming history.
setopt hist_ignore_dups         # do not record an event that was just recorded again.
setopt hist_ignore_all_dups     # delete an old recorded event if a new event is a duplicate.
setopt hist_find_no_dups        # do not display a previously found event.
setopt hist_ignore_space        # do not record an event starting with a space.
setopt hist_save_no_dups        # do not write a duplicate event to the history file.
setopt hist_verify              # do not execute immediately upon history expansion.
setopt hist_reduce_blanks       # remove blank lines

# +-----------+
# | VI KEYMAP |
# +-----------+

# vi mode
bindkey -v
export KEYTIMEOUT=1

# change cursor
source "$ZDOTDIR/plugin/cursor_mode"

# add vi text-objects for brackets and quotes, i.e. can be used with `a` (around) and `i` (inside)
autoload -Uz select-bracketed select-quoted
zle -N select-quoted
zle -N select-bracketed
for km in viopp visual; do
  bindkey -M $km -- '-' vi-up-line-or-history
  for c in {a,i}${(s..)^:-\'\"\`\|,./:;=+@}; do
    bindkey -M $km $c select-quoted
  done
  for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
    bindkey -M $km $c select-bracketed
  done
done

# emulation of vim-surround
autoload -Uz surround
zle -N delete-surround surround
zle -N add-surround surround
zle -N change-surround surround
bindkey -M vicmd cs change-surround
bindkey -M vicmd ds delete-surround
bindkey -M vicmd ys add-surround
bindkey -M visual S add-surround

# +---------+
# | OPTIONS |
# +---------+

zmodload zsh/complist

# use vim keys to navigate the menu selection
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# type of completion, e.g. suggests correction if there's a typo
zstyle ':completion:*' completer _extensions _complete _approximate
# enable completion menu
zstyle ':completion:*' menu select

# syntax highlight for file completion
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# use cache for completion
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$ZDOTDIR/.zcompcache"

# descriptors and corrections
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*' group-name ''

# case insensitivity and tab expansion
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# +------------------+
# | PLUGINS WITH ZIM |
# +------------------+

# download zimfw plugin manager if missing
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
      https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
fi

# install missing modules, and update ${zim_home}/init.zsh if missing or outdated
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi

# initialize modules
source ${ZIM_HOME}/init.zsh

# +----------+
# | COMPINIT |
# +----------+

fpath+="~/.zfunc"
# compinit is to be run last, after loading modules with zmodload etc
# autoload -Uz compinit && compinit             # not needed as we are using zim
autoload -Uz bashcompinit && bashcompinit

# +-------------+
# | COMPLETIONS |
# +-------------+

# `eval` commands are run **after** compinit

command -v jump > /dev/null && eval "$(jump shell zsh)"                                 # autojump between directories
command -v thefuck > /dev/null && eval "$(thefuck --alias)"                             # suggests a fix for a command run with a typo
command -v pyenv > /dev/null && eval "$(pyenv init --path)" && eval "$(pyenv init -)"   # python version manager
command -v pyenv-virtualenv > /dev/null && eval "$(pyenv virtualenv-init -)"            # python virtualenv manager
command -v python > /dev/null && eval "$(python -m pip completion --zsh)"               # python package manger
command -v pipx > /dev/null && eval "$(register-python-argcomplete pipx)"               # installer for python CLIs
command -v direnv > /dev/null && eval "$(direnv hook zsh)"                              # load project specific env variables

