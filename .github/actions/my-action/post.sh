#!/bin/bash

JOB_STATUS=$1

echo "📦 Running PSE cleanup"
echo "Job status: $GITHUB_PATH"
env
echo
echo " --------------------  SENDING DATA TO API START --------------------"
echo "|"
if [[ "$JOB_STATUS" == "success" ]]; then
  echo "| ✅ Whole job succeeded. Performing success cleanup."
else
  echo "| ❌ Job failed. Performing failure handling."
  # e.g., notify, rollback, cleanup
fi
echo "|"
echo " --------------------  SENDING DATA TO API COMPLETE --------------------"
echo
echo
