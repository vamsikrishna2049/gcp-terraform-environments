output "vpc_id" {
  value       = google_compute_network.vpc.id
  description = "Full VPC resource path"
}

output "vpc_name" {
  value       = google_compute_network.vpc.name
  description = "VPC name"
}

output "public_subnet_id" {
  value       = google_compute_subnetwork.public_subnet.id
  description = "Public subnet resource path"
}

output "private_subnet_id" {
  value       = google_compute_subnetwork.private_subnet.id
  description = "Private subnet resource path"
}

output "data_subnet_id" {
  value       = google_compute_subnetwork.data_subnet.id
  description = "Data subnet resource path"
}

output "nat_gateway_id" {
  value       = google_compute_router_nat.nat_gateway.id
  description = "Cloud NAT ID"
}
