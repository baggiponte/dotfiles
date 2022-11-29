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
	"paths"       # path env variables
	"options"     # setopt stuff
	"zstyle"      # completion menu, etc
	"vim"         # vim mode and double cursor
	"zim"         # zsh plugin manager
	"completions" # tab completion for installed binaries
	"functions"   # utility functions
	"aliases"     # utility aliases
)

for s in "${sources[@]}"; do
	# shellcheck source-path=./include
	source "$ZDOTDIR/include/${s}.zsh"
done
