# +-------------+
# | ZSH SETOPTS |
# +-------------+

# completions
setopt complete_in_word         # tab completion works from both sides
setopt extended_glob            # use extended globbing syntax.
setopt no_case_glob             # case insentive globbing
setopt glob_dots                # match dotfiles without specifying the dot

# cd
setopt auto_cd                  # go to folder path without using cd.
setopt cdable_vars              # change directory to a path stored in a variable.

# pushd/popd
setopt auto_pushd               # push the old directory onto the stack on cd.
# setopt pushd_ignore_dups        # do not store duplicates in the stack.
setopt pushd_silent             # do not print the directory stack after pushd or popd.

# rm
setopt rm_star_silent           # rm ./* does not request confirmation

# history
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
