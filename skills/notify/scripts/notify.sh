#!/usr/bin/env bash
# notify.sh — Send a push notification via ntfy
# Usage: notify.sh "Title" "Message" [priority] [click-url]
#
# Env (optional):
#   NTFY_TOPIC   — ntfy topic name (required)
#   NTFY_SERVER  — ntfy server URL (default: https://ntfy.sh)
#   NTFY_TOKEN   — access token for protected topics (optional)

set -euo pipefail

TITLE="${1:-}"
BODY="${2:-}"
PRIORITY="${3:-3}"
CLICK="${4:-}"

SERVER="${NTFY_SERVER:-https://ntfy.sh}"
TOPIC="${NTFY_TOPIC:-$(grep -sh '^NTFY_TOPIC=' ~/.config/notify/.env 2>/dev/null | tail -1 | cut -d= -f2-)}"
TOKEN="${NTFY_TOKEN:-}"

if [ -z "$TOPIC" ]; then
  echo "NTFY_TOPIC not set. Copy .env.example to ~/.config/notify/.env and set the topic." >&2
  exit 1
fi

if [ -z "$TITLE" ] || [ -z "$BODY" ]; then
  echo "Usage: notify.sh \"Title\" \"Message\" [priority] [click-url]" >&2
  exit 1
fi

HEADERS=(-H "Title: $TITLE" -H "Priority: $PRIORITY")
[ -n "$CLICK" ] && HEADERS+=("-H" "Click: $CLICK")
[ -n "$TOKEN" ] && HEADERS+=("-H" "Authorization: Bearer $TOKEN")

curl --silent --show-error --fail "${HEADERS[@]}" -d "$BODY" "$SERVER/$TOPIC"
