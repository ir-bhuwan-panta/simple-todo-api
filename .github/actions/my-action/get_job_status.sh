#!/bin/bash

# Exit on error
set -e

# Validate required environment variables
: "${GITHUB_TOKEN:?Missing GITHUB_TOKEN}"
: "${GITHUB_REPOSITORY_OWNER:?Missing OWNER}"
: "${REPO:?Missing REPO}"
: "${JOB_ID:?Missing JOB_ID}"

# Optional: GitHub API version
GITHUB_API_VERSION="${GITHUB_API_VERSION:-2022-11-28}"

# Call GitHub API
curl -sSL \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "X-GitHub-Api-Version: $GITHUB_API_VERSION" \
  "https://api.github.com/repos/$GITHUB_REPOSITORY/actions/jobs/$JOB_ID"
