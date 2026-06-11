output "network_vpc_id" {
  value       = module.network.vpc_id
  description = "Network VPC ID"
}

output "instance_ids" {
  value       = module.compute_vm.vm_ids
  description = "Compute instance IDs"
}

output "cloud_sql_connection_name" {
  value       = module.cloud_sql.instance_connection_name
  description = "Cloud SQL connection name"
}
