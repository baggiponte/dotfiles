# +-------------+
# | ZSH SETOPTS |
# +-------------+

# +-----------------------------------------------------------------+
# | REFERENCES                                                      |
# | * history: https://zsh.sourceforge.io/Guide/zshguide02.html#l17 |
# +-----------------------------------------------------------------+

histfile="${XDG_CACHE_HOME:-"$HOME/.cache"}/zsh/history"

mkdir -p "${histfile:h}"

export HISTFILE="$histfile"
HISTSIZE=1200000
SAVEHIST=1000000

unset histfile

setopt complete_in_word       # tab completion works from both sides.
setopt extended_glob          # use extended globbing syntax.
setopt no_case_glob           # case insentive globbing.
setopt glob_dots              # match dotfiles without specifying the dot
setopt auto_cd                # go to folder path without using cd.
setopt cdable_vars            # change directory to a path stored in a variable.
setopt auto_pushd             # push the old directory onto the stack on cd.
setopt pushd_silent           # do not print the directory stack after pushd or popd.
setopt rm_star_silent         # rm ./* does not request confirmation.
setopt share_history          # share history between all sessions.
setopt extended_history       # write the history file in the ':start:elapsed;command' format.
setopt hist_ignore_all_dups   # remove duplicate entries.
setopt hist_find_no_dups      # if duplicate lines have been saved, search backwards does not show them more than once.
setopt hist_ignore_space      # do not record an event starting with a space.
setopt hist_reduce_blanks     # remove blank lines.
setopt hist_no_store          # do not save `history` calls in history.
setopt hist_no_functions      # do not save function definitions in history.
setopt hist_verify            # do not execute immediately upon history expansion.

# Disable Ctrl-D shell exit: on an empty line ^D would exit the shell,
# closing the tmux pane. With ignore_eof, ^D is ignored at an empty
# prompt ("use 'exit' to exit the zsh") and still deletes a char on a
# non-empty line. `exit` closes the shell normally.
setopt ignore_eof
