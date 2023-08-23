# +---------------------------------------------------------------------+
# | Bindings                                                            |
# |                                                                     |
# | bind functions to keybindings                                       |
# | * https://thevaluable.dev/zsh-line-editor-configuration-mouseless/  |
# +---------------------------------------------------------------------+

# +-------------------------+
# | Edit command in $EDITOR |
# +-------------------------+

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^E' edit-command-line

# +-----------+
# | Live grep |
# +-----------+

zle -N live-grep
bindkey '^g' live-grep

# +------------+
# | Fuzzy find |
# +------------+

zle -N fuzzy-find
bindkey '^f' fuzzy-find

# # +--------+
# # | Zoxide |
# # +--------+
#
# # see: https://unix.stackexchange.com/a/703707/402599
# _zle-zoxide() {
# 	zoxide-interactive
# 	zle -I
# }
#
# zle -N _zle-zoxide
# bindkey '^w' _zle-zoxide
#
# # +---------------------+
# # | Zoxide + Fuzzy find |
# # +---------------------+
#
# _zle-zoxide_fuzzy-find() {
# 	zoxide-interactive
# 	zle -I
# 	fuzzy-find
# }
#
# zle -N _zle-zoxide_fuzzy-find
# bindkey '^P' _zle-zoxide_fuzzy-find
#
# # +--------------------+
# # | Zoxide + Live grep |
# # +--------------------+
#
# _zle-zoxide_live-grep() {
# 	zoxide-interactive
# 	zle -I
# 	live-grep
# }
#
# zle -N _zle-zoxide_live-grep
# bindkey '^O' _zle-zoxide_live-grep
