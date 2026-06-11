# Compute VM Module

This Terraform module creates Google Compute Engine VM instances with count-based scaling and dedicated service accounts.

## Resources

- `google_compute_instance.instances`
- `google_service_account.vm_sa`
- `google_compute_instance_iam_member.vm_sa_binding`

## Inputs

- `project_id`
- `zone`
- `environment`
- `vpc_id`
- `subnet_id`
- `machine_type`
- `vm_count`
- `vm_names`
- `assign_public_ip`
- `disk_size_gb`

## Outputs

- `vm_ids`
- `vm_internal_ips`
- `vm_service_accounts`
