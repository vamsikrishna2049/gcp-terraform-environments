# Prod Environment Backend Usage

This folder uses a partial Terraform backend configuration.

`backend.tf` declares the backend type:

```hcl
terraform {
  backend "gcs" {}
}
```

`backend.hcl` provides the prod-specific GCS state location:

```hcl
bucket = "gcplearning-15042026-terraform-state-prod"
prefix = "terraform/state/prod"
```

## Local Terraform Usage

Run Terraform from this environment folder:

```bash
cd gcp-terraform-live/environments/prod
terraform init -backend-config=backend.hcl
terraform plan
```

If the backend bucket changes, reconfigure Terraform:

```bash
terraform init -reconfigure -backend-config=backend.hcl
```

## Cloud Build Usage

Cloud Build does not use this `backend.hcl` file directly. The Cloud Build pipeline passes backend values dynamically:

```bash
terraform init \
  -backend-config="bucket=${STATE_PROJECT_ID}-terraform-state-prod" \
  -backend-config="prefix=terraform/state/prod"
```

For automatic Cloud Build triggers, set this trigger substitution:

```text
_ENVIRONMENT=prod
```

Leave `_STATE_PROJECT_ID` empty if the state bucket is in the same project where the Cloud Build trigger runs.

## Before Running

Make sure the bucket exists:

```bash
gsutil ls gs://gcplearning-15042026-terraform-state-prod
```

This environment is configured for project `gcplearning-15042026`. Update `backend.hcl` and `terraform.tfvars` if you move prod to a different project.
