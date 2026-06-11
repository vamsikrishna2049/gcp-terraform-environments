output "secret_ids" {
  value       = { for key, secret in google_secret_manager_secret.secret : key => secret.id }
  description = "Secret IDs by name"
}

output "secret_versions" {
  value       = { for key, version in google_secret_manager_secret_version.secret_version : key => version.id }
  description = "Secret version paths"
}
