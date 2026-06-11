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

variable "rotation_service_image" {
  type        = string
  description = "Artifact Registry image URL for secret rotation service"
  validation {
    condition     = length(trim(var.rotation_service_image)) > 0
    error_message = "rotation_service_image must not be empty"
  }
}

variable "cloud_sql_instance_name" {
  type        = string
  description = "Cloud SQL instance name"
  validation {
    condition     = length(trim(var.cloud_sql_instance_name)) > 0
    error_message = "cloud_sql_instance_name must not be empty"
  }
}

variable "secret_id" {
  type        = string
  description = "Secret ID to rotate"
  validation {
    condition     = length(trim(var.secret_id)) > 0
    error_message = "secret_id must not be empty"
  }
}

variable "rotation_schedule" {
  type        = string
  description = "Cron schedule for secret rotation"
  default     = "0 3 * * 0"
}
