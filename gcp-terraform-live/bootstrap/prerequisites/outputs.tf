output "enabled_services" {
  description = "APIs enabled by the bootstrap."
  value       = sort([for service in google_project_service.required : service.service])
}

output "terraform_state_buckets" {
  description = "Terraform state buckets by environment."
  value       = { for env, bucket in google_storage_bucket.terraform_state : env => bucket.name }
}

output "cloudbuild_artifacts_bucket" {
  description = "Bucket used by Cloud Build pipeline artifacts."
  value       = google_storage_bucket.cloudbuild_artifacts.name
}

output "terraform_service_accounts" {
  description = "Terraform service accounts by environment."
  value       = { for env, sa in google_service_account.terraform : env => sa.email }
}

output "cloud_build_service_account_email" {
  description = "Cloud Build service account granted impersonation access."
  value       = local.cloud_build_service_account_email
}

output "db_password_secret_ids" {
  description = "DB password Secret Manager IDs by environment."
  value       = { for env, secret in google_secret_manager_secret.db_password : env => secret.id }
}

output "artifact_registry_repository" {
  description = "Artifact Registry Docker repository resource."
  value       = google_artifact_registry_repository.docker.name
}
