#!/bin/bash

# Exit on any error
set -e

# Validate required env variables
: "${GITHUB_TOKEN:?GITHUB_TOKEN is required}"
: "${GITHUB_REPOSITORY:?GITHUB_REPOSITORY is required (format: owner/repo)}"
: "${GITHUB_RUN_ID:?GITHUB_RUN_ID is required}"

# Optional settings
GITHUB_API_VERSION="${GITHUB_API_VERSION:-2022-11-28}"
OUTPUT_FILE="${OUTPUT_FILE:-logs.zip}"
EXTRACT_DIR="${EXTRACT_DIR:-logs}"

# Download workflow run logs
sleep 3000
curl -sSL \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "X-GitHub-Api-Version: $GITHUB_API_VERSION" \
  "https://api.github.com/repos/$GITHUB_REPOSITORY/actions/runs/$GITHUB_RUN_ID/logs" \
  -o "$OUTPUT_FILE"
echo "Present working dorectory"
pwd
echo "✅ Logs downloaded to $OUTPUT_FILE"

# Extract logs
mkdir -p "$EXTRACT_DIR"
unzip -q "$OUTPUT_FILE" -d "$EXTRACT_DIR"
echo "📂 Logs extracted to $EXTRACT_DIR/"

# Print all logs to stdout
echo "📄 Showing log contents:"
echo "-----------------------------"

# Print contents of all log files
find "$EXTRACT_DIR" -type f -name '*.txt' | while read -r logfile; do
  echo "▶️ $logfile"
  echo "-----------------------------"
  cat "$logfile"
  echo ""
done
