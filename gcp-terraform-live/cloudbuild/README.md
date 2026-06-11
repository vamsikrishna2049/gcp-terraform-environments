# Cloud Build Pipelines

This folder provides native Google Cloud Build pipeline definitions for the Terraform live repo. GitHub Actions workflows are still present as an optional fallback, but Cloud Build can be used as the primary CI/CD runner.

## Pipeline Files

- `terraform-plan.yaml` - Runs `terraform fmt`, `terraform init`, `terraform validate`, `terraform plan`, `tflint`, `tfsec`, and `checkov`.
- `terraform-apply.yaml` - Runs `terraform init`, `terraform plan`, `terraform apply`, and `scripts/post-deploy-validation.sh`.
- `drift-detection.yaml` - Runs `terraform plan -detailed-exitcode` for drift detection.
- `build-rotator.yaml` - Runs Bandit, builds the Cloud SQL secret rotator image, scans it with Trivy, and pushes to Artifact Registry.
- `dast-scan.yaml` - Runs OWASP ZAP baseline or active scans against a target URL.

## Required Setup

Enable the required APIs:

```bash
gcloud services enable cloudbuild.googleapis.com artifactregistry.googleapis.com storage.googleapis.com
```

Create the Cloud Build artifact bucket used by these configs:

```bash
gsutil mb -l us-central1 gs://PROJECT_ID-cloudbuild-artifacts
```

Grant the Cloud Build service account the minimum permissions it needs. Replace `PROJECT_NUMBER`, `PROJECT_ID`, and the Terraform service account names:

```bash
gcloud iam service-accounts add-iam-policy-binding terraform-dev@PROJECT_ID.iam.gserviceaccount.com \
  --member="serviceAccount:PROJECT_NUMBER@cloudbuild.gserviceaccount.com" \
  --role="roles/iam.serviceAccountTokenCreator"
```

Repeat the impersonation binding for `terraform-stage` and `terraform-prod` if Cloud Build deploys those environments.

## Manual Runs

Plan dev:

```bash
gcloud builds submit . \
  --config=cloudbuild/terraform-plan.yaml \
  --substitutions=_ENVIRONMENT=dev
```

Apply dev:

```bash
gcloud builds submit . \
  --config=cloudbuild/terraform-apply.yaml \
  --substitutions=_ENVIRONMENT=dev
```

Check drift:

```bash
gcloud builds submit . \
  --config=cloudbuild/drift-detection.yaml \
  --substitutions=_ENVIRONMENT=dev
```

By default, the Terraform state bucket is resolved as:

```text
${PROJECT_ID}-terraform-state-${_ENVIRONMENT}
```

`PROJECT_ID` is the Google Cloud project where the Cloud Build job runs. If your Terraform state bucket is in a different project, pass `_STATE_PROJECT_ID`:

```bash
gcloud builds submit . \
  --config=cloudbuild/terraform-plan.yaml \
  --substitutions=_ENVIRONMENT=prod,_STATE_PROJECT_ID=my-shared-state-project
```

Build rotator image:

```bash
gcloud builds submit .. \
  --config=gcp-terraform-live/cloudbuild/build-rotator.yaml \
  --substitutions=_REGION=us-central1,_REPOSITORY=docker-repo,_IMAGE_NAME=cloudsql-secret-rotator
```

Run DAST:

```bash
gcloud builds submit . \
  --config=cloudbuild/dast-scan.yaml \
  --substitutions=_TARGET_URL=https://YOUR_LOAD_BALANCER_URL,_SCAN_MODE=baseline
```

## Recommended Triggers

Create separate Cloud Build triggers:

1. Pull request trigger using `cloudbuild/terraform-plan.yaml` with `_ENVIRONMENT=dev`.
2. Manual trigger for `cloudbuild/terraform-apply.yaml` per environment. Enable Cloud Build trigger approval for stage and prod.
3. Scheduled trigger for `cloudbuild/drift-detection.yaml` per environment.
4. Push trigger for `cloudbuild/build-rotator.yaml` when the rotator service changes.
5. Scheduled or manual trigger for `cloudbuild/dast-scan.yaml`.

For split repositories, adjust `_ROTATOR_DIR` or connect a trigger to the repository that contains `services/cloudsql-secret-rotator`.

## Automatic Trigger Substitutions

Do not edit the YAML file every time you change environments. When using Cloud Build automatic triggers, create one trigger per environment and set substitutions on the trigger.

Example trigger setup:

| Trigger | Config file | Branch | Substitutions |
|---|---|---|---|
| `terraform-plan-dev` | `cloudbuild/terraform-plan.yaml` | pull request / dev branch | `_ENVIRONMENT=dev` |
| `terraform-plan-stage` | `cloudbuild/terraform-plan.yaml` | pull request / stage branch | `_ENVIRONMENT=stage` |
| `terraform-plan-prod` | `cloudbuild/terraform-plan.yaml` | pull request / main branch | `_ENVIRONMENT=prod` |
| `terraform-apply-dev` | `cloudbuild/terraform-apply.yaml` | main branch or manual trigger | `_ENVIRONMENT=dev` |
| `terraform-apply-stage` | `cloudbuild/terraform-apply.yaml` | manual trigger | `_ENVIRONMENT=stage` |
| `terraform-apply-prod` | `cloudbuild/terraform-apply.yaml` | manual trigger with approval | `_ENVIRONMENT=prod` |

For most projects, leave `_STATE_PROJECT_ID` empty. Cloud Build will use the project that owns the trigger:

```text
${PROJECT_ID}-terraform-state-${_ENVIRONMENT}
```

Only set `_STATE_PROJECT_ID` in the trigger if your Terraform state bucket is stored in a different/shared project.
