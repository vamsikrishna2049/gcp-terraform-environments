# Secret Manager Module

This Terraform module creates secrets in Google Cloud Secret Manager and stores versions for each secret.

## Resources

- `google_secret_manager_secret.secret`
- `google_secret_manager_secret_version.secret_version`

## Inputs

- `project_id`
- `environment`
- `secret_configs`

## Outputs

- `secret_ids`
- `secret_versions`
