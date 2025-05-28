#!/bin/bash

# Configuration
GITHUB_TOKEN=$1
REPO_OWNER=$2
REPO_NAME=$3
RUN_ATTEMPT=$4
OUTPUT_DIR="job_logs_$(date +%s)"
ZIP_FILE="all_jobs_logs.zip"

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Function to check if API response is successful
is_success() {
    local response="$1"
    local status_code=$(echo "$response" | grep -oP '(?<=HTTP/\d\.\d )\d+')
    [[ "$status_code" -ge 200 && "$status_code" -lt 300 ]]
}

# Function to download logs for a single job
download_job_logs() {
    local job_id=$1
    local output_file="$OUTPUT_DIR/${job_id}.txt"
    
    echo "Downloading logs for job: $job_id"
    
    # Make API call to get job logs
    response=$(curl -s -w "\n%{http_code}" \
        -H "Authorization: Bearer $GITHUB_TOKEN" \
        -H "Accept: application/vnd.github.v3+json" \
        "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/actions/jobs/$job_id/logs")
    
    # Separate body and status code
    http_code=$(echo "$response" | tail -n1)
    content=$(echo "$response" | head -n -1)
    
    if is_success "$http_code"; then
        echo "$content" > "$output_file"
        echo "✅ Successfully saved logs for job $job_id"
        return 0
    else
        echo "❌ Failed to download logs for job $job_id (HTTP $http_code)"
        return 1
    fi
}

# Main function to process all jobs
download_all_logs() {
    # Convert comma-separated list to array
    IFS=',' read -ra JOB_IDS <<< "$ALL_JOB_IDS"
    
    for job_id in "${JOB_IDS[@]}"; do
        download_job_logs "$job_id"
    done
    
    # Zip all downloaded logs
    zip -r "$ZIP_FILE" "$OUTPUT_DIR"
    echo "📦 All logs zipped to $ZIP_FILE"
    
    # Clean up temporary directory
    rm -rf "$OUTPUT_DIR"
}

# Execute main function
download_all_logs
