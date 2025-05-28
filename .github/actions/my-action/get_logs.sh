#!/bin/bash
set -euo pipefail

run_analysis() {
    echo "Starting log analysis in mode: $MODE"
    
    if [[ "$MODE" != "analyze" ]]; then
        echo "Running in standard mode"
        return 0
    fi

    # Create output directory
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local log_dir="job_logs_${timestamp}"
    local zip_file="all_logs_${timestamp}.zip"
    
    mkdir -p "$log_dir"
    echo "Created log directory: $log_dir"

    # Function to download job logs
    download_job_logs() {
        local job_id="$1"
        local output_file="${log_dir}/${job_id}.log"
        
        echo "Downloading logs for job: $job_id"
        
        # Use the GitHub CLI to download logs
        if gh run view --repo "$GITHUB_REPOSITORY" --job "$job_id" --log > "$output_file"; then
            echo "✅ Saved logs for job $job_id"
            return 0
        else
            # Fallback to API method if CLI fails
            echo "⚠️ GitHub CLI failed, trying API method"
            local api_url="${GITHUB_API_URL}/repos/${GITHUB_REPOSITORY}/actions/jobs/${job_id}/logs"
            
            # Get the redirect URL
            redirect_url=$(curl -sI \
                -H "Authorization: Bearer $GITHUB_TOKEN" \
                -H "Accept: application/vnd.github.v3+json" \
                "$api_url" | grep -i '^location:' | awk '{print $2}' | tr -d '\r')
            
            if [ -z "$redirect_url" ]; then
                echo "❌ Failed to get redirect URL for job $job_id"
                echo "Logs unavailable for job $job_id" > "$output_file"
                return 1
            fi
            
            # Download the actual logs
            status_code=$(curl -s -w "%{http_code}" -L -o "$output_file" \
                -H "Authorization: Bearer $GITHUB_TOKEN" \
                "$redirect_url")
            
            if [[ "$status_code" -ge 200 && "$status_code" -lt 300 ]]; then
                echo "✅ Saved logs for job $job_id (via API)"
                return 0
            else
                echo "❌ Failed to download logs for job $job_id (HTTP $status_code)"
                echo "Logs download failed (HTTP $status_code)" > "$output_file"
                return 1
            fi
        fi
    }

    # Process all job IDs
    if [[ -n "${ALL_JOB_IDS:-}" ]]; then
        echo "Processing job IDs: $ALL_JOB_IDS"
        IFS=',' read -ra JOB_ID_ARRAY <<< "$ALL_JOB_IDS"
        
        for job_id in "${JOB_ID_ARRAY[@]}"; do
            download_job_logs "$job_id" || true
        done
    else
        echo "⚠️ No job IDs provided for analysis"
        echo "No jobs to process" > "${log_dir}/no_jobs.txt"
    fi

    # Create zip archive
    zip -r "$zip_file" "$log_dir"
    echo "📦 Created log archive: $zip_file"
    
    # Cleanup temporary files
    rm -rf "$log_dir"
    
    # Set output for the zip file path
    echo "log_archive=$zip_file" >> $GITHUB_OUTPUT
    echo "::notice title=Log Analysis Complete::Log archive created at $zip_file"
    echo "📂 Absolute path: $(pwd)/$zip_file"
}

run_analysis
