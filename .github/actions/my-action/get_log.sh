    # Capture the curl response into a variable
    API_RESPONSE=$(curl -L \
      -H "Accept: application/vnd.github+json" \
      -H "Authorization: Bearer $GITHUB_TOKEN" \
      -H "X-GitHub-Api-Version: 2022-11-28" \
      "https://api.github.com/repos/$GITHUB_REPOSITORY/actions/jobs/$PSE_JOB_ID/logs")

    # Echo the variable to display its content in the logs
    env
    echo "API Response:"
    echo "$API_RESPONSE"
