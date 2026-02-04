#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_FILE="${SCRIPT_DIR}/audio_route_swift.swift"
BINARY_FILE="/tmp/sketchybar-audio-route-swift"

build_if_needed() {
  if [[ ! -x "${BINARY_FILE}" || "${SOURCE_FILE}" -nt "${BINARY_FILE}" ]]; then
    local sdk_path
    sdk_path="$(xcrun --show-sdk-path)"
    xcrun swiftc -O \
      -module-cache-path "/tmp/codex-swift-module-cache" \
      -sdk "${sdk_path}" \
      "${SOURCE_FILE}" -o "${BINARY_FILE}"
  fi
}

decode_base64() {
  python3 - "$1" <<'PY'
import base64
import sys

value = sys.argv[1] if len(sys.argv) > 1 else ""
try:
    print(base64.b64decode(value).decode("utf-8"))
except Exception:
    print("")
PY
}

build_if_needed

action="${1:-status}"
if [[ "${action}" == "select" ]]; then
  kind="${2:-output}"
  encoded="${3:-}"
  device="$(decode_base64 "${encoded}")"
  exec "${BINARY_FILE}" select "${kind}" "${device}"
fi

exec "${BINARY_FILE}" "$@"
