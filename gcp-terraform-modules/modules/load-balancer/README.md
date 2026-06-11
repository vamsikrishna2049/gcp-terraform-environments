# Load Balancer Module

This Terraform module creates an HTTPS load balancer with Cloud Armor WAF and optional CDN for GCP.

## Resources

- `google_compute_global_address.static_ip`
- `google_compute_ssl_certificate.ssl_cert`
- `google_compute_health_check.health_check`
- `google_compute_instance_group.instance_group`
- `google_compute_backend_service.backend_service`
- `google_compute_security_policy.cloud_armor`
- `google_compute_url_map.url_map`
- `google_compute_target_https_proxy.https_proxy`
- `google_compute_global_forwarding_rule.https_forwarding`

## Inputs

- `project_id`
- `environment`
- `vm_instance_ids`
- `zone`
- `backend_port`
- `health_check_path`
- `health_check_interval`
- `cdn_enabled`
- `cloud_armor_enabled`
- `domain_name`

## Outputs

- `load_balancer_ip`
- `load_balancer_url`
- `backend_service_id`
