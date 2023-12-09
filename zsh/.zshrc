# +-------------------------------------------------------------------------+
# | REFERENCES                                                              |
# | * https://scriptingosx.com/2019/06/moving-to-zsh-part-3-shell-options/  |
# | * https://linux.die.net/man/1/zshoptions                                |
# | * https://thevaluable.dev/zsh-completion-guide-examples/                |
# +-------------------------------------------------------------------------+

# +-------------------------------------------------------------------------+
# | MODULES                                                                 |
# | I use the module layout as it encourages to write self-contained and    |
# | small files. Hopefully, this improves navigation and readability.       |
# +-------------------------------------------------------------------------+

# +----------------+
# | ORDER MATTERS! |
# +----------------+
sources=(
	"paths"       # set path env variables
	"options"     # configure zsh
	"zstyle"      # configure completion menu, etc
	"vim"         # enable vim modes and cursor
	"zim"         # zsh plugin manager
	"autocomp"    # dump missing autocompletions
	"eval"        # shell hooks (e.g. promtp, rtx)
	"functions"   # frequently used functions
	"aliases"     # utility aliases
	"bindkeys"    # bind functions to keymaps
)

for s in "${sources[@]}"; do
	# shellcheck source-path=./include
	source "$ZDOTDIR/include/${s}.zsh"
done

if [[ ! -v ZELLIJ ]]; then
    zellij-switcher
fi

typeset -U PATH
