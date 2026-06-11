output "vm_ids" {
  value       = google_compute_instance.instances[*].id
  description = "Instance IDs"
}

output "vm_internal_ips" {
  value       = google_compute_instance.instances[*].network_interface[0].network_ip
  description = "Internal IP addresses"
}

output "vm_service_accounts" {
  value       = google_service_account.vm_sa[*].email
  description = "Service account emails"
}
