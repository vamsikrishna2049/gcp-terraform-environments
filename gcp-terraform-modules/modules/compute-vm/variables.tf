variable "project_id" {
  type        = string
  description = "GCP project ID"
  validation {
    condition     = length(trim(var.project_id)) > 0
    error_message = "project_id must not be empty"
  }
}

variable "zone" {
  type        = string
  description = "GCP zone"
  validation {
    condition     = can(regex("^[a-z]+[0-9]+-[a-z0-9-]+-[0-9]+$", var.zone))
    error_message = "zone must be a valid GCP zone"
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

variable "vpc_id" {
  type        = string
  description = "VPC resource ID"
  validation {
    condition     = length(trim(var.vpc_id)) > 0
    error_message = "vpc_id must not be empty"
  }
}

variable "subnet_id" {
  type        = string
  description = "Subnet resource ID"
  validation {
    condition     = length(trim(var.subnet_id)) > 0
    error_message = "subnet_id must not be empty"
  }
}

variable "machine_type" {
  type        = string
  description = "Compute instance machine type"
  validation {
    condition     = length(trim(var.machine_type)) > 0
    error_message = "machine_type must not be empty"
  }
}

variable "vm_count" {
  type        = number
  description = "Number of VM instances"
  validation {
    condition     = var.vm_count >= 1 && var.vm_count <= 5
    error_message = "vm_count must be between 1 and 5"
  }
}

variable "vm_names" {
  type        = list(string)
  description = "Explicit names for VM instances"
  validation {
    condition     = length(var.vm_names) >= var.vm_count
    error_message = "vm_names must contain at least vm_count items"
  }
}

variable "assign_public_ip" {
  type        = bool
  description = "Whether to assign public IP addresses"
  validation {
    condition     = var.assign_public_ip == false
    error_message = "assign_public_ip must be false"
  }
}

variable "disk_size_gb" {
  type        = number
  description = "Boot disk size in GB"
  default     = 20
  validation {
    condition     = var.disk_size_gb >= 10
    error_message = "disk_size_gb must be at least 10"
  }
}
