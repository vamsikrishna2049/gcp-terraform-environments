output "service_id" {
  value       = google_cloud_run_v2_service.app_service.id
  description = "Service ID"
}

output "service_url" {
  value       = google_cloud_run_v2_service.app_service.uri
  description = "Service URL"
}

output "service_revision" {
  value       = google_cloud_run_v2_service.app_service.latest_ready_revision
  description = "Latest revision"
}
