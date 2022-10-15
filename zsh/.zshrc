# +-------------------------------------------------------------------------+
# | REFERENCES                                                              |
# | * https://scriptingosx.com/2019/06/moving-to-zsh-part-3-shell-options/  |
# | * https://linux.die.net/man/1/zshoptions                                |
# | * https://thevaluable.dev/zsh-completion-guide-examples/                |
# +-------------------------------------------------------------------------+

# +-------------------------------------------------------------------------+
# | MODULES                                                                 |
# | I use the module layout as it encourages to write self-contained and    |
# | small files. Hopefully, this improves navigation and readability. The   |
# | first downside is that **ORDER MATTERS** when sourcing the modules in   |
# | `./include/`!                                                           |
# +-------------------------------------------------------------------------+

sources=(
  "paths"         # core path env variables
  "envvars"       # other env vars used for configs
  "zim"           # zsh plugin manager
  "options"       # setopt stuff
  "zstyle"        # completion menu, etc
  "vim"           # vim mode and double cursor
  "completions"   # tab completion for installed binaries
  "functions"     # utility functions
  "aliases"       # utility aliases
  # "conda"       # setup for conda/mamba
)

for s in "${sources[@]}"; do
  # shellcheck source-path=./include
  source "$ZDOTDIR/include/${s}.zsh"
done
