# +-------------------+
# | DEFAULT VARIABLES |
# +-------------------+

# see https://wiki.archlinux.org/title/XDG_Base_Directory
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# codex
export CODEX_HOME="${XDG_CONFIG_HOME:-$HOME/.config}/codex"

# pi coding agent — keep config inside the dotfiles repo (see pi/.gitignore rules)
export PI_CODING_AGENT_DIR="$XDG_CONFIG_HOME/pi/agent"

# pi-otel fallbacks: the extension reads the legacy agent dir directly (no
# PI_CODING_AGENT_DIR support as of v0.3.0); the token itself lives in .secrets
export OTEL_EXPORTER_OTLP_ENDPOINT="https://logfire-eu.pydantic.dev"
export OTEL_EXPORTER_OTLP_PROTOCOL="http/protobuf"
export OTEL_SERVICE_NAME="pi"
export PI_OTEL_SPAN_NAMING="genai"
export PI_OTEL_CAPTURE_CONTENT="metadata_only"

export DISABLE_TELEMETRY=1
