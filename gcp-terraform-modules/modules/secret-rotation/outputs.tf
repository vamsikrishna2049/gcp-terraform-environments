output "rotation_service_account" {
  value       = google_service_account.rotation_sa.email
  description = "Service account email"
}

output "rotation_service_url" {
  value       = google_cloud_run_v2_service.rotation_svc.uri
  description = "Cloud Run service URL"
}

output "rotation_job_id" {
  value       = google_cloud_scheduler_job.rotation_job.id
  description = "Cloud Scheduler job ID"
}
