# +-------------------------------------------------------------------------+
# | REFERENCES                                                              |
# | * https://scriptingosx.com/2019/06/moving-to-zsh-part-3-shell-options/  |
# | * https://linux.die.net/man/1/zshoptions                                |
# | * https://thevaluable.dev/zsh-completion-guide-examples/                |
# +-------------------------------------------------------------------------+

# +------------+
# | MY MODULES |
# +------------+

# stuff in $ZDOTDIR/include
# ORDER MATTERS!
sources=(
  "options"       # setopt stuff
  "zstyle"        # completion menu, etc
  "vim"           # vim mode and double cursor
  "completions"   # tab completion for installed binaries
  "functions"     # utility functions
  "aliases"       # utility aliases
  # "python"       # setup for pdm and conda/mamba
)

for s in "${sources[@]}"; do
  source $ZDOTDIR/include/${s}.zsh
done
