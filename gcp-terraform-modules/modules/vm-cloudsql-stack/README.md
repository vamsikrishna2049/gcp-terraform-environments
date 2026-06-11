# VM Cloud SQL Stack Module

This composite Terraform module deploys a network, compute VM instances, a Cloud SQL PostgreSQL database, and an HTTPS load balancer.

## Modules

- `module.network`
- `module.compute_vm`
- `module.cloud_sql`
- `module.load_balancer`

## Inputs

- `project_id`
- `region`
- `zone`
- `environment`
- `cidr_block`
- `public_cidr`
- `private_cidr`
- `data_cidr`
- `vm_names`
- `machine_type`
- `db_instance_name`
- `db_password_secret_id`
- `domain_name`
