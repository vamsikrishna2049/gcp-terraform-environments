variable "project_id" {
  type        = string
  description = "GCP project ID"
  validation {
    condition     = can(regex("^[a-z0-9-]{6,30}$", var.project_id))
    error_message = "Project ID must be 6-30 lowercase letters, numbers, hyphens"
  }
}

variable "region" {
  type        = string
  description = "GCP region"
  default     = "us-central1"
  validation {
    condition     = contains(["us-central1", "us-east1", "us-west1"], var.region)
    error_message = "Region must be us-central1, us-east1, or us-west1"
  }
}

variable "environment" {
  type        = string
  description = "Environment name"
  validation {
    condition     = var.environment == "dev"
    error_message = "Must be dev for this configuration"
  }
}

variable "zone" {
  type        = string
  description = "GCP zone"
  default     = "us-central1-a"
  validation {
    condition     = startswith(var.zone, "${var.region}-")
    error_message = "Zone must belong to the selected region."
  }
}

variable "terraform_service_account" {
  type        = string
  description = "Service account email to impersonate for Terraform"
  validation {
    condition     = can(regex("^terraform-dev@[a-z0-9-]{6,30}\\.iam\\.gserviceaccount\\.com$", var.terraform_service_account))
    error_message = "Terraform service account must be the dev Terraform service account for this project."
  }
}

variable "cidr_block" {
  type        = string
  description = "VPC CIDR block"
  validation {
    condition     = can(cidrhost(var.cidr_block, 0))
    error_message = "VPC CIDR block must be valid CIDR notation."
  }
}

variable "public_cidr" {
  type        = string
  description = "Public subnet CIDR"
  validation {
    condition     = can(cidrhost(var.public_cidr, 0))
    error_message = "Public subnet CIDR must be valid CIDR notation."
  }
}

variable "private_cidr" {
  type        = string
  description = "Private subnet CIDR"
  validation {
    condition     = can(cidrhost(var.private_cidr, 0))
    error_message = "Private subnet CIDR must be valid CIDR notation."
  }
}

variable "data_cidr" {
  type        = string
  description = "Data subnet CIDR"
  validation {
    condition     = can(cidrhost(var.data_cidr, 0))
    error_message = "Data subnet CIDR must be valid CIDR notation."
  }
}

variable "web_machine_type" {
  type        = string
  description = "Machine type for web VMs"
  validation {
    condition     = can(regex("^(e2|n1|n2|n2d|c2|c2d|c3|t2d)-[a-z0-9-]+-[0-9]+$", var.web_machine_type))
    error_message = "Web machine type must be a supported general-purpose or compute-optimized GCE machine type."
  }
}

variable "web_vm_count" {
  type        = number
  description = "Number of web VMs"
  validation {
    condition     = var.web_vm_count >= 1 && var.web_vm_count <= 5
    error_message = "Web VM count must be between 1 and 5."
  }
}

variable "web_vm_names" {
  type        = list(string)
  description = "Names for web VMs"
  validation {
    condition     = length(var.web_vm_names) == var.web_vm_count && alltrue([for name in var.web_vm_names : can(regex("^dev-[a-z][a-z0-9-]{1,61}[a-z0-9]$", name))])
    error_message = "Web VM names must match web_vm_count and use dev-prefixed RFC1035-compatible names."
  }
}

variable "db_password_secret_id" {
  type        = string
  description = "Secret ID for the database password"
  sensitive   = true
  validation {
    condition     = can(regex("^projects/[a-z0-9-]{6,30}/secrets/db-password-dev/versions/(latest|[0-9]+)$", var.db_password_secret_id))
    error_message = "Database password secret must reference the dev database password secret version."
  }
}
