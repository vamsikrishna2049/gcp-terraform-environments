# Cloud SQL Postgres Module

This Terraform module deploys a managed Cloud SQL PostgreSQL 16 instance with private IP, backups, and optional high availability.

## Resources

- `google_sql_database_instance.instance`
- `google_sql_database.default_database`
- `google_sql_user.db_user`
- `google_sql_database_instance_iam_member.cloud_sql_client`
- `google_sql_backup_run.backup`

## Inputs

- `project_id`
- `region`
- `environment`
- `instance_name`
- `database_name`
- `db_username`
- `db_password_secret_id`
- `private_vpc_connector_id`
- `backup_location`
- `availability_type`
- `backup_configuration`
- `instance_tier`
- `cloud_sql_client_service_account`

## Outputs

- `instance_id`
- `instance_connection_name`
- `instance_private_ip`
- `instance_self_link`
