#!/bin/bash
set -euo pipefail

# Main function for log analysis
analyze_logs() {
    if [[ "$MODE" != "analyze" ]]; then
        echo "Running in standard mode"
        # Add your normal action logic here
        return 0
    fi

    echo "Starting log analysis"
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local log_dir="job_logs_${timestamp}"
    local zip_file="all_logs_${timestamp}.zip"
    
    mkdir -p "$log_dir"
    
    # Function to check API response
    is_success() {
        local response="$1"
        local status_code=$(echo "$response" | grep -oP '(?<=HTTP/\d\.\d )\d+')
        [[ "$status_code" -ge 200 && "$status_code" -lt 300 ]]
    }

    # Function to download logs
    download_job_logs() {
        local job_id="$1"
        local output_file="${log_dir}/${job_id}.log"
        
        echo "Downloading logs for job: $job_id"
        response=$(curl -s -w "\n%{http_code}" -L \
            -H "Authorization: Bearer $GITHUB_TOKEN" \
            -H "Accept: application/vnd.github.v3+json" \
            "https://api.github.com/repos/$GITHUB_REPOSITORY/actions/jobs/$job_id/logs")
        
        http_code=$(echo "$response" | tail -n1)
        content=$(echo "$response" | head -n -1)
        
        if is_success "$http_code"; then
            echo "$content" > "$output_file"
            echo "✅ Saved logs for job $job_id"
        else
            echo "❌ Failed to download logs for job $job_id (HTTP $http_code)"
            echo "error" > "$output_file"
        fi
    }

    # Process all job IDs
    if [[ -n "$ALL_JOB_IDS" ]]; then
        echo "Processing job IDs: $ALL_JOB_IDS"
        IFS=',' read -ra JOB_ID_ARRAY <<< "$ALL_JOB_IDS"
        for job_id in "${JOB_ID_ARRAY[@]}"; do
            download_job_logs "$job_id"
        done
    else
        echo "⚠️ No job IDs provided for analysis"
    fi

    # Create zip archive
    zip -r "$zip_file" "$log_dir"
    echo "📦 Created log archive: $zip_file"
    
    # Cleanup and set output
    rm -rf "$log_dir"
    echo "::set-output name=log_archive::$zip_file"
    echo "::notice title=Log Analysis Complete::Log archive available at $zip_file"
}

# Run the main function
analyze_logs
