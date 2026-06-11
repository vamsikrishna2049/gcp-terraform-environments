# Cloud Build Pipelines

These are the GCP-native CI/CD pipelines for `nodejs-app`. GitHub Actions remain in the repo, but Cloud Build can be used as the primary pipeline runner.

## Pipeline Files

- `ci.yaml` - Runs `npm ci`, lint, coverage tests, and `npm audit`.
- `build.yaml` - Builds the Docker image, scans it with Trivy, and pushes immutable plus `latest` tags.
- `deploy-cloud-run.yaml` - Builds, scans, pushes, and deploys to Cloud Run.
- `dast.yaml` - Runs OWASP ZAP baseline or active scan against a deployed URL.
- `sonar.yaml` - Runs coverage and SonarCloud/SonarQube scan using Secret Manager.

## Required Setup

Enable APIs:

```bash
gcloud services enable cloudbuild.googleapis.com artifactregistry.googleapis.com run.googleapis.com secretmanager.googleapis.com storage.googleapis.com
```

Create the artifacts bucket:

```bash
gsutil mb -l us-central1 gs://PROJECT_ID-cloudbuild-artifacts
```

Create an Artifact Registry Docker repository:

```bash
gcloud artifacts repositories create apps \
  --repository-format=docker \
  --location=us-central1 \
  --description="Application images"
```

Store optional Sonar token:

```bash
printf '%s' 'SONAR_TOKEN_VALUE' | gcloud secrets create sonar-token --data-file=-
```

## Manual Runs

CI:

```bash
gcloud builds submit . --config=cloudbuild/ci.yaml
```

Build and push:

```bash
gcloud builds submit . \
  --config=cloudbuild/build.yaml \
  --substitutions=_REGION=us-central1,_REPOSITORY=apps,_IMAGE_NAME=nodejs-app
```

Deploy to Cloud Run:

```bash
gcloud builds submit . \
  --config=cloudbuild/deploy-cloud-run.yaml \
  --substitutions=_REGION=us-central1,_REPOSITORY=apps,_IMAGE_NAME=nodejs-app,_SERVICE_NAME=nodejs-app,_DB_HOST=PRIVATE_DB_IP,_RUNTIME_SERVICE_ACCOUNT=nodejs-app-runtime@PROJECT_ID.iam.gserviceaccount.com
```

DAST:

```bash
gcloud builds submit . \
  --config=cloudbuild/dast.yaml \
  --substitutions=_TARGET_URL=https://SERVICE_URL,_SCAN_MODE=baseline
```

Sonar:

```bash
gcloud builds submit . --config=cloudbuild/sonar.yaml
```

## Recommended Triggers

Create Cloud Build triggers instead of relying on GitHub Actions:

| Trigger | Config file | Event |
|---|---|---|
| `nodejs-ci-pr` | `cloudbuild/ci.yaml` | Pull request |
| `nodejs-build-main` | `cloudbuild/build.yaml` | Push to `main` |
| `nodejs-deploy-dev` | `cloudbuild/deploy-cloud-run.yaml` | Push to `main` or manual |
| `nodejs-deploy-stage` | `cloudbuild/deploy-cloud-run.yaml` | Manual with approval |
| `nodejs-deploy-prod` | `cloudbuild/deploy-cloud-run.yaml` | Manual with approval |
| `nodejs-dast` | `cloudbuild/dast.yaml` | Scheduled or after deployment |
| `nodejs-sonar` | `cloudbuild/sonar.yaml` | Pull request or push |
