#!/usr/bin/env bash
# Verify the S1-mini post-processing chain end to end.
#
# Prereqs:
#   1. llama.app is running (menu bar > the little llama icon), so its server
#      is up on http://localhost:9931/v1 and the model is installed.
#   2. Handy is configured (see the settings you already set).
#
# This fires the EXACT request Handy sends (single user message, no system
# message, reasoning_effort=none) at the llama.app endpoint. If the custom
# chat template is wired up, the response should be the cleaned sentence.

RAW="so um i need to like send the the report by uh friday no wait make that thursday"

curl -s http://localhost:9931/v1/chat/completions \
  -H 'Content-Type: application/json' \
  -d "{
    \"model\": \"superwhisper/s1-mini-GGUF:Q4_K_M\",
    \"messages\": [
      {\"role\": \"user\", \"content\": \"[Styling: semi-formal] [Structure: prose] [Context: general]\n${RAW}\"}
    ],
    \"reasoning_effort\": \"none\",
    \"temperature\": 0
  }" | python3 -c 'import sys,json; print(json.load(sys.stdin)["choices"][0]["message"]["content"])'
