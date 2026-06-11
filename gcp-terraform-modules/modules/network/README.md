# Network Module

This Terraform module creates a custom VPC, subnets, Cloud NAT, and firewall rules for a GCP environment.

## Resources

- `google_compute_network.vpc`
- `google_compute_subnetwork.public_subnet`
- `google_compute_subnetwork.private_subnet`
- `google_compute_subnetwork.data_subnet`
- `google_compute_router.nat_router`
- `google_compute_router_nat.nat_gateway`
- `google_compute_firewall.allow_internal`
- `google_compute_firewall.allow_health_checks`
- `google_compute_firewall.allow_ssh_iap`
- `google_compute_firewall.allow_db_internal`

## Inputs

- `project_id`
- `region`
- `environment`
- `cidr_block`
- `public_cidr`
- `private_cidr`
- `data_cidr`

## Outputs

- `vpc_id`
- `vpc_name`
- `public_subnet_id`
- `private_subnet_id`
- `data_subnet_id`
- `nat_gateway_id`
