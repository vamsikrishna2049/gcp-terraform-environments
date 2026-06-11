# GCP Prerequisites Bootstrap

This Terraform layer creates the GCP prerequisites required before running the live environment Terraform in `environments/dev`, `environments/stage`, or `environments/prod`.

It creates:

- Required GCP APIs
- Terraform state buckets for dev, stage, and prod
- Cloud Build artifacts bucket
- Terraform service accounts for dev, stage, and prod
- IAM roles for Terraform service accounts
- Cloud Build impersonation permissions
- Secret Manager database password secrets
- Artifact Registry Docker repository

## One-Time Setup

Copy the example variables file:

```bash
cd gcp-terraform-live/bootstrap/prerequisites
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` if needed. For your current project, keep:

```hcl
project_id = "gcplearning-15042026"
region     = "us-central1"
```

## Run Bootstrap

Run this with a user or service account that already has permission to enable APIs, create buckets, create service accounts, manage IAM, create secrets, and create Artifact Registry repositories.

```bash
terraform init
terraform plan
terraform apply
```

## Important Notes

This bootstrap uses local Terraform state by default. That is intentional because the remote state buckets do not exist until this layer creates them.

After this succeeds, run the environment Terraform with the GCS backend:

```bash
cd ../../environments/dev
terraform init -backend-config=backend.hcl
terraform plan
```

## Cloud Build Service Account

By default, this grants impersonation access to:

```text
PROJECT_NUMBER@cloudbuild.gserviceaccount.com
```

If your project uses a custom Cloud Build service account, set this in `terraform.tfvars`:

```hcl
cloud_build_service_account_email = "my-cloud-build-sa@gcplearning-15042026.iam.gserviceaccount.com"
```

## Outputs To Check

After apply, check:

```bash
terraform output terraform_state_buckets
terraform output terraform_service_accounts
terraform output db_password_secret_ids
terraform output artifact_registry_repository
```
