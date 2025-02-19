# source secret env variables, such as API keys
if [ -f "${XDG_CONFIG_HOME}/.secrets" ]; then
    source "${XDG_CONFIG_HOME}/.secrets"
fi
