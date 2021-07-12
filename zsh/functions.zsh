## trash files instead of `rm` them.
trash () { command mv "$@" ~/.Trash ; }

## make a directory and cd into it
take () { mkdir -p "$1" && cd "$1"; }

## create a custom function to use gitignore.io to create .gitignore files
gi() { curl -sLw "\n" https://www.toptal.com/developers/gitignore/api/$@ ;}

## extract any file from a compressed archive (e.g. .zip format)


## nice idea, does not work
# includes arrow into echo script
# arrow (COLOR) {
#     echo "${BOLD}${COLOR:=$CYAN}==> ${RESET}"
# }
