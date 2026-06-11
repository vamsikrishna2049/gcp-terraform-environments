variable "project_id" {
  type        = string
  description = "GCP project ID"
  validation {
    condition     = length(trim(var.project_id)) > 0
    error_message = "project_id must not be empty"
  }
}

variable "region" {
  type        = string
  description = "GCP region"
  validation {
    condition     = can(regex("^[a-z]+[0-9]+-[a-z0-9-]+$", var.region))
    error_message = "region must be a valid GCP region"
  }
}

variable "environment" {
  type        = string
  description = "Deployment environment"
  validation {
    condition     = var.environment == "dev" || var.environment == "stage" || var.environment == "prod"
    error_message = "environment must be dev, stage, or prod"
  }
}

variable "instance_name" {
  type        = string
  description = "Cloud SQL instance name"
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.instance_name))
    error_message = "instance_name must only contain lowercase letters, numbers, and hyphens"
  }
}

variable "database_name" {
  type        = string
  description = "Database name"
  default     = "app_db"
  validation {
    condition     = length(trim(var.database_name)) > 0
    error_message = "database_name must not be empty"
  }
}

variable "db_username" {
  type        = string
  description = "Database user name"
  default     = "app_user"
  validation {
    condition     = length(trim(var.db_username)) > 0
    error_message = "db_username must not be empty"
  }
}

variable "db_password_secret_id" {
  type        = string
  description = "Cloud Secret Manager secret payload or secret identifier for the database password"
  sensitive   = true
  validation {
    condition     = length(trim(var.db_password_secret_id)) > 0
    error_message = "db_password_secret_id must not be empty"
  }
}

variable "private_vpc_connector_id" {
  type        = string
  description = "Private VPC connector resource path for Cloud SQL private IP"
  default     = ""
}

variable "backup_location" {
  type        = string
  description = "Region for backups"
  default     = ""
}

variable "availability_type" {
  type        = string
  description = "Availability type for Cloud SQL instance"
  default     = "ZONAL"
  validation {
    condition     = var.availability_type == "ZONAL" || var.availability_type == "REGIONAL"
    error_message = "availability_type must be ZONAL or REGIONAL"
  }
}

variable "backup_configuration" {
  type = object({
    enabled                        = bool
    start_time                     = string
    point_in_time_recovery_enabled = bool
    transaction_log_retention_days = number
    backup_retention_settings = object({
      retained_backups = number
      retention_unit   = string
    })
  })
  default = {
    enabled                        = true
    start_time                     = "03:00"
    point_in_time_recovery_enabled = true
    transaction_log_retention_days = 7
    backup_retention_settings = {
      retained_backups = 30
      retention_unit   = "COUNT"
    }
  }
}

variable "instance_tier" {
  type        = string
  description = "Cloud SQL instance tier"
  default     = "db-custom-1-3840"
}

variable "cloud_sql_client_service_account" {
  type        = string
  description = "Optional service account email to grant Cloud SQL client access"
  default     = ""
}
