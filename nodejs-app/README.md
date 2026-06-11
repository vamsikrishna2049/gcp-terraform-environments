# Node.js Application

This repository contains a Node.js Express application designed for deployment on GCP Cloud Run.

## Features

- Health endpoint: `/health`
- CRUD user API: `/users`
- PostgreSQL connection via environment variables
- Request logging, rate limiting, and sensitive data redaction
- Security headers, disabled Express fingerprinting, and JSON body limits
- CI checks for linting, tests, coverage, dependency audit, SAST, image scanning, and optional DAST

## Scripts

- `npm start`
- `npm test`
- `npm run lint`

## Required CI/CD Secrets

- `GCP_PROJECT_ID`
- `WIF_PROVIDER`
- `WIF_SERVICE_ACCOUNT`
- `SONAR_TOKEN` for SonarCloud
- `DAST_TARGET_URL` for OWASP ZAP baseline scanning

## Docker

Build:

```bash
docker build -t nodejs-app:latest .
```

## Cloud Build CI/CD

Native Google Cloud Build pipeline definitions are available in `cloudbuild/`.

- `cloudbuild/ci.yaml` runs install, lint, tests, coverage, and dependency audit.
- `cloudbuild/build.yaml` builds, scans, and pushes the Docker image.
- `cloudbuild/deploy-cloud-run.yaml` builds, scans, pushes, and deploys to Cloud Run.
- `cloudbuild/dast.yaml` runs OWASP ZAP against a deployed URL.
- `cloudbuild/sonar.yaml` runs Sonar analysis with a token stored in Secret Manager.

GitHub Actions workflows are kept in `.github/workflows`, but Cloud Build can be used as the primary CI/CD path. See `cloudbuild/README.md` for trigger setup and manual commands.

## Local Validation

```bash
npm ci
npm run lint
npm run test:coverage
npm audit --audit-level=high
docker build -t nodejs-app:local .
```
