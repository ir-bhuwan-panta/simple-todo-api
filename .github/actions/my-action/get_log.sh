if [[ "$MODE" != "analyze" ]]; then
    echo "Running in standard mode"
    # Add your normal action logic here
    return 0
fi

echo curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/$GITHUB_REPOSITORY/actions/jobs/$PSE_JOB_ID/logs
