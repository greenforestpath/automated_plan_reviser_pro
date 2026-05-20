#!/usr/bin/env bash
# Start Chrome with remote debugging for Oracle/APR
# Usage: ./scripts/start-chrome-oracle.sh

CHROME_PORT="${CHROME_PORT:-9222}"
CHROME_DATA_DIR="${CHROME_DATA_DIR:-$HOME/.chrome-oracle}"

# Check if already running
if lsof -i ":$CHROME_PORT" &>/dev/null; then
    echo "Chrome already running on port $CHROME_PORT"
    exit 0
fi

echo "Starting Chrome with remote debugging on port $CHROME_PORT..."
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
    --remote-debugging-port="$CHROME_PORT" \
    --user-data-dir="$CHROME_DATA_DIR" \
    "https://chatgpt.com" &

sleep 2
echo "Chrome started. Login session saved to: $CHROME_DATA_DIR"
echo "Oracle can connect with: --remote-chrome localhost:$CHROME_PORT"
