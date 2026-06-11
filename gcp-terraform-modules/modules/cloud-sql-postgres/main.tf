resource "google_sql_database_instance" "instance" {
  project          = var.project_id
  name             = var.instance_name
  region           = var.region
  database_version = "POSTGRES_16"

  settings {
    tier              = var.instance_tier
    availability_type = var.availability_type

    dynamic "backup_configuration" {
      for_each = var.backup_configuration.enabled ? [1] : []
      content {
        enabled                        = var.backup_configuration.enabled
        start_time                     = var.backup_configuration.start_time
        point_in_time_recovery_enabled = var.backup_configuration.point_in_time_recovery_enabled
        transaction_log_retention_days = var.backup_configuration.transaction_log_retention_days

        backup_retention_settings {
          retained_backups = var.backup_configuration.backup_retention_settings.retained_backups
          retention_unit   = var.backup_configuration.backup_retention_settings.retention_unit
        }
      }
    }

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.private_vpc_connector_id
    }
  }
}

resource "google_sql_database" "default_database" {
  project  = var.project_id
  instance = google_sql_database_instance.instance.name
  name     = var.database_name
}

data "google_secret_manager_secret_version" "db_password" {
  secret  = var.db_password_secret_id
  version = "latest"
}

resource "google_sql_user" "db_user" {
  project  = var.project_id
  instance = google_sql_database_instance.instance.name
  name     = var.db_username
  password = data.google_secret_manager_secret_version.db_password.secret_data
}

resource "google_sql_database_instance_iam_member" "cloud_sql_client" {
  count    = var.cloud_sql_client_service_account != "" ? 1 : 0
  project  = var.project_id
  instance = google_sql_database_instance.instance.name
  role     = "roles/cloudsql.client"
  member   = "serviceAccount:${var.cloud_sql_client_service_account}"
}

resource "google_sql_backup_run" "backup" {
  count      = var.backup_configuration.enabled ? 1 : 0
  project    = var.project_id
  instance   = google_sql_database_instance.instance.name
  description = "On-demand backup for ${var.environment} database"
}
