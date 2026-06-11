#!/bin/bash
set -e

ENVIRONMENT=$1
PROJECT_ID=$2

if [ -z "$ENVIRONMENT" ] || [ -z "$PROJECT_ID" ]; then
  echo "Usage: post-deploy-validation.sh <ENVIRONMENT> <PROJECT_ID>"
  exit 1
fi

echo "=== Post-Deployment Validation for ${ENVIRONMENT} ==="

echo "Checking VMs..."
RUNNING_VMS=$(gcloud compute instances list --project="${PROJECT_ID}" --filter="status:RUNNING" --format="value(name)" | wc -l)
echo "✓ Running VMs: ${RUNNING_VMS}"

echo "Checking Cloud SQL..."
gcloud sql instances describe "${ENVIRONMENT}-postgres" --project="${PROJECT_ID}" | grep -q "RUNNABLE" && echo "✓ Cloud SQL is AVAILABLE"

echo "Checking health endpoint..."
LB_IP=$(gcloud compute forwarding-rules list --global --project="${PROJECT_ID}" --format="value(IPAddress)" | head -n1)
if curl -s "http://${LB_IP}/health" | grep -q "ok"; then
  echo "✓ Health check passed"
else
  echo "Health check failed"
  exit 1
fi

echo "=== All checks passed ==="
