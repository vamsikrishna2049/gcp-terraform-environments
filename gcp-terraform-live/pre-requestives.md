Before using this `gcp-terraform-live` project, prepare these GCP prerequisites.

**Required GCP Project**
Your project is:

```text
gcplearning-15042026
```

Set it locally:

```bash
gcloud config set project gcplearning-15042026
```

**Enable APIs**
```bash
gcloud services enable \
  cloudbuild.googleapis.com \
  compute.googleapis.com \
  sqladmin.googleapis.com \
  secretmanager.googleapis.com \
  servicenetworking.googleapis.com \
  iam.googleapis.com \
  artifactregistry.googleapis.com \
  storage.googleapis.com
```

**Terraform State Buckets**
Create one GCS bucket per environment:

```bash
gsutil mb -p gcplearning-15042026 -l us-central1 gs://gcplearning-15042026-terraform-state-dev
gsutil mb -p gcplearning-15042026 -l us-central1 gs://gcplearning-15042026-terraform-state-stage
gsutil mb -p gcplearning-15042026 -l us-central1 gs://gcplearning-15042026-terraform-state-prod
```

Enable versioning:

```bash
gsutil versioning set on gs://gcplearning-15042026-terraform-state-dev
gsutil versioning set on gs://gcplearning-15042026-terraform-state-stage
gsutil versioning set on gs://gcplearning-15042026-terraform-state-prod
```

**Cloud Build Artifact Bucket**
Used by Cloud Build logs/artifacts from your pipeline configs:

```bash
gsutil mb -p gcplearning-15042026 -l us-central1 gs://gcplearning-15042026-cloudbuild-artifacts
```

**Terraform Service Accounts**
Create one per environment:

```bash
gcloud iam service-accounts create terraform-dev \
  --display-name="Terraform Dev"

gcloud iam service-accounts create terraform-stage \
  --display-name="Terraform Stage"

gcloud iam service-accounts create terraform-prod \
  --display-name="Terraform Prod"
```

These match your `terraform.tfvars` values:

```text
terraform-dev@gcplearning-15042026.iam.gserviceaccount.com
terraform-stage@gcplearning-15042026.iam.gserviceaccount.com
terraform-prod@gcplearning-15042026.iam.gserviceaccount.com
```

**IAM Roles For Terraform**
For learning/lab use, you can start broad:

```bash
gcloud projects add-iam-policy-binding gcplearning-15042026 \
  --member="serviceAccount:terraform-dev@gcplearning-15042026.iam.gserviceaccount.com" \
  --role="roles/editor"
```

Repeat for `terraform-stage` and `terraform-prod`.

For production, replace `roles/editor` with least-privilege roles.

**Allow Cloud Build To Impersonate Terraform SAs**
Get your project number:

```bash
gcloud projects describe gcplearning-15042026 --format="value(projectNumber)"
```

Then grant impersonation:

```bash
gcloud iam service-accounts add-iam-policy-binding \
  terraform-dev@gcplearning-15042026.iam.gserviceaccount.com \
  --member="serviceAccount:PROJECT_NUMBER@cloudbuild.gserviceaccount.com" \
  --role="roles/iam.serviceAccountTokenCreator"
```

Repeat for `terraform-stage` and `terraform-prod`.

**Database Password Secrets**
Create one secret per environment:

```bash
printf 'CHANGE_ME_DEV_PASSWORD' | gcloud secrets create db-password-dev \
  --data-file=- \
  --replication-policy="automatic"

printf 'CHANGE_ME_STAGE_PASSWORD' | gcloud secrets create db-password-stage \
  --data-file=- \
  --replication-policy="automatic"

printf 'CHANGE_ME_PROD_PASSWORD' | gcloud secrets create db-password-prod \
  --data-file=- \
  --replication-policy="automatic"
```

These match:

```text
projects/gcplearning-15042026/secrets/db-password-dev/versions/latest
projects/gcplearning-15042026/secrets/db-password-stage/versions/latest
projects/gcplearning-15042026/secrets/db-password-prod/versions/latest
```

**Cloud Build Triggers**
Create Cloud Build triggers for:

```text
terraform-plan-dev      _ENVIRONMENT=dev
terraform-plan-stage    _ENVIRONMENT=stage
terraform-plan-prod     _ENVIRONMENT=prod

terraform-apply-dev     _ENVIRONMENT=dev
terraform-apply-stage   _ENVIRONMENT=stage
terraform-apply-prod    _ENVIRONMENT=prod
```

For stage/prod apply triggers, enable manual approval.

**Local Tools**
If running locally, install:

```text
gcloud CLI
Terraform
gsutil
Docker
```

First local test for dev:

```bash
cd gcp-terraform-live/environments/dev
terraform init -backend-config=backend.hcl
terraform plan
```