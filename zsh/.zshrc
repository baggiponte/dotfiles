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
    "eval"        # shell hooks and completions
	"functions"   # frequently used functions
	"aliases"     # utility aliases
	"bindkeys"    # bind functions to keymaps
    "secrets"
)

for s in "${sources[@]}"; do
	# shellcheck source-path=./include
	source "$ZDOTDIR/include/${s}.zsh"
done
