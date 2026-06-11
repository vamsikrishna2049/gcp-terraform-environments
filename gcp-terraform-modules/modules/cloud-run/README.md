# Cloud Run Module

This Terraform module deploys a containerized application on Cloud Run with no public access and secret access granted via Secret Manager IAM.

## Resources

- `google_cloud_run_v2_service.app_service`
- `google_secret_manager_secret_iam_member.secret_access`

## Inputs

- `project_id`
- `region`
- `environment`
- `image_url`
- `container_port`
- `cpu`
- `memory`
- `max_instance_count`
- `secret_id`
- `service_account_email`

## Outputs

- `service_id`
- `service_url`
- `service_revision`
