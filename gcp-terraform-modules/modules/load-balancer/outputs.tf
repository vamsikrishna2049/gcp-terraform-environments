output "load_balancer_ip" {
  value       = google_compute_global_address.static_ip.address
  description = "Static IP address"
}

output "load_balancer_url" {
  value       = "https://${google_compute_global_address.static_ip.address}"
  description = "HTTPS URL"
}

output "backend_service_id" {
  value       = google_compute_backend_service.backend_service.id
  description = "Backend service ID"
}
