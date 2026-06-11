output "instance_id" {
  value       = google_sql_database_instance.instance.id
  description = "Instance ID"
}

output "instance_connection_name" {
  value       = google_sql_database_instance.instance.connection_name
  description = "For Cloud SQL Auth Proxy"
}

output "instance_private_ip" {
  value       = google_sql_database_instance.instance.ip_address[0].ip_address
  description = "Private IP address"
}

output "instance_self_link" {
  value       = google_sql_database_instance.instance.self_link
  description = "Resource self-link"
}
