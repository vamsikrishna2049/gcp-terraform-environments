#!/bin/bash

set -e

PROJECT_ID=$1
ENVIRONMENT=$2

if [ -z "$PROJECT_ID" ] || [ -z "$ENVIRONMENT" ]; then
  echo "Usage: bootstrap.sh <PROJECT_ID> <ENVIRONMENT>"
  exit 1
fi

BUCKET_NAME="${PROJECT_ID}-terraform-state-${ENVIRONMENT}"

gsutil mb -p "$PROJECT_ID" -l us-central1 "gs://${BUCKET_NAME}" || true

gsutil versioning set on "gs://${BUCKET_NAME}"

gcloud iam service-accounts create "terraform-${ENVIRONMENT}" \
  --display-name="Terraform ${ENVIRONMENT}" \
  --project="${PROJECT_ID}" || true

gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
  --member="serviceAccount:terraform-${ENVIRONMENT}@${PROJECT_ID}.iam.gserviceaccount.com" \
  --role="roles/compute.instanceAdmin.v1"

gcloud services enable compute.googleapis.com sqladmin.googleapis.com secretmanager.googleapis.com pubsub.googleapis.com eventarc.googleapis.com cloudbuild.googleapis.com cloudresourcemanager.googleapis.com --project="${PROJECT_ID}"

echo "Bootstrap complete for ${PROJECT_ID}/${ENVIRONMENT}"
