# Stage Environment Backend Usage

This folder uses a partial Terraform backend configuration.

`backend.tf` declares the backend type:

```hcl
terraform {
  backend "gcs" {}
}
```

`backend.hcl` provides the stage-specific GCS state location:

```hcl
bucket = "gcplearning-15042026-terraform-state-stage"
prefix = "terraform/state/stage"
```

## Local Terraform Usage

Run Terraform from this environment folder:

```bash
cd gcp-terraform-live/environments/stage
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
  -backend-config="bucket=${STATE_PROJECT_ID}-terraform-state-stage" \
  -backend-config="prefix=terraform/state/stage"
```

For automatic Cloud Build triggers, set this trigger substitution:

```text
_ENVIRONMENT=stage
```

Leave `_STATE_PROJECT_ID` empty if the state bucket is in the same project where the Cloud Build trigger runs.

## Before Running

Make sure the bucket exists:

```bash
gsutil ls gs://gcplearning-15042026-terraform-state-stage
```

This environment is configured for project `gcplearning-15042026`. Update `backend.hcl` and `terraform.tfvars` if you move stage to a different project.
