# define variables to easily set different colors and formatting options when echo:
# echo "${RED} hello" will output red text.

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
VIOLET=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
GREY=$(tput setaf 8)

BOLD=$(tput bold)
RESET=$(tput sgr0)
