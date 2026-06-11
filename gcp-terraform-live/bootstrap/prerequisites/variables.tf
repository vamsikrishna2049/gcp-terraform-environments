variable "project_id" {
  type        = string
  description = "GCP project ID where prerequisites will be created."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "Project ID must be 6-30 lowercase letters, numbers, and hyphens, starting with a letter and ending with a letter or number."
  }
}

variable "region" {
  type        = string
  description = "Default region for buckets and Artifact Registry."
  default     = "us-central1"
}

variable "environments" {
  type        = set(string)
  description = "Environment names to bootstrap."
  default     = ["dev", "stage", "prod"]

  validation {
    condition     = alltrue([for env in var.environments : contains(["dev", "stage", "prod"], env)])
    error_message = "Supported environments are dev, stage, and prod."
  }
}

variable "state_bucket_force_destroy" {
  type        = bool
  description = "Allow Terraform to delete state buckets even when they contain objects. Keep false for normal use."
  default     = false
}

variable "artifact_bucket_force_destroy" {
  type        = bool
  description = "Allow Terraform to delete the Cloud Build artifacts bucket even when it contains objects."
  default     = false
}

variable "artifact_registry_repository_id" {
  type        = string
  description = "Artifact Registry Docker repository ID."
  default     = "docker-repo"
}

variable "terraform_service_account_roles" {
  type        = set(string)
  description = "Project IAM roles granted to each Terraform service account."
  default = [
    "roles/artifactregistry.admin",
    "roles/cloudsql.admin",
    "roles/compute.admin",
    "roles/iam.serviceAccountAdmin",
    "roles/iam.serviceAccountUser",
    "roles/secretmanager.admin",
    "roles/servicenetworking.networksAdmin",
    "roles/storage.admin",
  ]
}

variable "cloud_build_service_account_email" {
  type        = string
  description = "Cloud Build service account that can impersonate Terraform service accounts. Leave empty to use PROJECT_NUMBER@cloudbuild.gserviceaccount.com."
  default     = ""
}

variable "create_db_password_versions" {
  type        = bool
  description = "Create generated password versions for db-password-{environment} secrets."
  default     = true
}

variable "db_password_length" {
  type        = number
  description = "Length for generated DB passwords."
  default     = 24

  validation {
    condition     = var.db_password_length >= 16
    error_message = "DB password length must be at least 16."
  }
}
