# GCP Terraform Live

Environment-specific Terraform configurations for dev, stage, and prod.

## Structure

- `environments/dev`
- `environments/stage`
- `environments/prod`
- `scripts`
- `.github/workflows`
- `cloudbuild`

## Usage

Each environment directory contains its own Terraform configuration and variables. Use the provided scripts for validation, drift detection, and cleanup.

## DevSecOps Controls

This repo includes the live infrastructure controls for the DevSecOps workflow:

- Terraform formatting and validation in CI.
- Per-environment plan/apply for `dev`, `stage`, and `prod`.
- Workload Identity Federation for GitHub Actions authentication to GCP.
- Least-privilege GitHub Actions permissions.
- Scheduled drift detection with issue creation.
- IaC scanning with `tflint`, `tfsec`, and `checkov`.
- Optional SonarCloud scanning when `SONAR_TOKEN` is configured.
- Optional OWASP ZAP DAST scans when `DAST_TARGET_DEV`, `DAST_TARGET_STAGE`, or `DAST_TARGET_PROD` are configured.
- Container image scanning with Trivy for the rotator workflow when the rotator source exists.
- Provider supply-chain pinning with `.terraform.lock.hcl`.
- Remote module pinning to a commit SHA.

## Required GitHub Secrets

- `WIF_PROVIDER`
- `WIF_SERVICE_ACCOUNT`
- `GCP_PROJECT_ID`
- `SONAR_TOKEN` for SonarCloud
- `DAST_TARGET_DEV` for dev DAST
- `DAST_TARGET_STAGE` for stage DAST
- `DAST_TARGET_PROD` for prod DAST
- `ARTIFACT_REGISTRY_IMAGE` for the rotator image workflow

## Local Validation

Run the checks from this directory:

```bash
terraform fmt -check -recursive
python3 -c 'import pathlib, yaml; [yaml.safe_load(open(p)) for p in list(pathlib.Path(".github/workflows").glob("*.yml")) + list(pathlib.Path("cloudbuild").glob("*.yaml"))]; print("yaml ok")'
git diff --check
```

Validate bootstrap:

```bash
cd bootstrap/prerequisites
terraform init -backend=false -input=false
terraform validate
```

Validate an environment:

```bash
cd environments/dev
terraform init -backend=false -input=false
terraform validate
```

Note: if you update reusable Terraform modules, push the module repo first and then update the pinned module commit SHA in `environments/*/main.tf`.

## Cloud Build CI/CD

Native Google Cloud Build pipeline definitions are available in `cloudbuild/`:

- `cloudbuild/terraform-plan.yaml`
- `cloudbuild/terraform-apply.yaml`
- `cloudbuild/drift-detection.yaml`
- `cloudbuild/build-rotator.yaml`
- `cloudbuild/dast-scan.yaml`

Start with the setup and trigger instructions in `cloudbuild/README.md`.
