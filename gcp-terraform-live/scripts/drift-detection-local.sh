#!/bin/bash
set -e

if [ -z "$1" ]; then
  echo "Usage: drift-detection-local.sh <environment-directory>"
  exit 1
fi

cd "$1"

echo "Running terraform plan for drift detection in $1"
terraform init
terraform plan -detailed-exitcode || true
EXIT_CODE=$?

if [ "$EXIT_CODE" -eq 2 ]; then
  echo "Drift detected"
  exit 2
fi

if [ "$EXIT_CODE" -eq 0 ]; then
  echo "No drift detected"
  exit 0
fi

exit $EXIT_CODE
