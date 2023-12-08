# +-------+
# | Utils |
# +-------+

path () {
    print "${PATH//:/\\n}"
}

fpath (){
    print "${fpath}" | tr " " "\n"
}

brew-graph () {
    brew list -1 --formula | while read -r cask; do
    print -ne "\x1B[1;34m $cask \x1B[0m"
    brew uses "$cask" --installed | awk '{printf(" %s ", $0)}'
    print ""
    done
}

# +-------------------+
# | Almost never used |
# +-------------------+

if [ -x /Applications/RStudio.app ]; then
    rstudio () {
        # check if there is an .Rproj file
        local files=(*.Rproj(N))

        # if the number of files is not 0, then remove them
        if [ $(($#files)) -eq 1 ]; then
            open -a RStudio "${files[1]}"
        elif [ $(($#files)) -gt 1 ]; then
            print "Multiple *.Rproj files found."
        else
            print "No .Rproj file found, just launching RStudio"
            open -a RStudio
        fi
    }
fi

# extract files
extract() {
 ex() {
    case $1 in
        *.tar.bz2)  tar xjf "$1"      ;;
        *.tar.gz)   tar xzf "$1"      ;;
        *.bz2)      bunzip2 "$1"      ;;
        *.gz)       gunzip "$1"       ;;
        *.tar)      tar xf "$1"       ;;
        *.tbz2)     tar xjf "$1"      ;;
        *.tgz)      tar xzf "$1"      ;;
        *.zip)      unzip "$1"        ;;
        *.7z)       7z x "$1"         ;; # require p7zip
        *.rar)      7z x "$1"         ;; # require p7zip
        *.iso)      7z x "$1"         ;; # require p7zip
        *.Z)        uncompress "$1"   ;;
        *)          print "$1 cannot be extracted" ;;
    esac
    }

    for file in "$@"
    do
        if [ -f "$file" ]; then
            ex "$file"
        else
            print "'$file' is not a valid file"
        fi
    done
}

generate-pw () {
    local num_char="${1:-32}"

    openssl rand -base64 "$num_char" | tee /dev/tty | pbcopy
}

colortest () {
    fg=""
    bg=""
    for i in {0..255}; do
        a=$(printf "\\x1b[38;5;%sm%3d\\e[0m " "$i" "$i")
        b=$(printf "\\x1b[48;5;%sm%3d\\e[0m " "$i" "$i")
        fg+="$a"
        bg+="$b"
        if (( "$i" % 5 ==0 )); then
            print -e "$fg\\t\\t$bg"
            fg=""
            bg=""
        else
            fg+="  "
            bg+="  "
        fi
    done
}

# bulk rename extensions
rename-ext() {
    requires fd

    local ext_old="$1"
    local ext_new="$2"

    fd -e "$ext_old" -x mv "{}" "{.}.$ext_new"
}
