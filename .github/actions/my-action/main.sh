#!/bin/bash
set -e

echo "📦 Running PSE main logic"

# Your main logic here
# Simulate some work
sleep 1

# Simulate success
echo "✅ Main logic completed"

# Set success marker
MARKER_FILE="$RUNNER_TEMP/pse-success.marker"
touch "$MARKER_FILE"
