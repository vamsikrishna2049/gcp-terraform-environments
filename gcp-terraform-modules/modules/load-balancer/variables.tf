variable "project_id" {
  type        = string
  description = "GCP project ID"
  validation {
    condition     = length(trim(var.project_id)) > 0
    error_message = "project_id must not be empty"
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

variable "vm_instance_ids" {
  type        = list(string)
  description = "List of VM instance self links"
  validation {
    condition     = length(var.vm_instance_ids) > 0
    error_message = "vm_instance_ids must contain at least one instance self-link"
  }
}

variable "zone" {
  type        = string
  description = "Zone for the instance group"
  validation {
    condition     = can(regex("^[a-z]+[0-9]+-[a-z0-9-]+-[0-9]+$", var.zone))
    error_message = "zone must be a valid GCP zone"
  }
}

variable "backend_port" {
  type        = number
  description = "Backend service port"
  default     = 80
}

variable "health_check_path" {
  type        = string
  description = "Path for health checks"
  default     = "/health"
}

variable "health_check_interval" {
  type        = number
  description = "Health check interval in seconds"
  default     = 10
}

variable "cdn_enabled" {
  type        = bool
  description = "Enable Cloud CDN"
  default     = true
}

variable "cloud_armor_enabled" {
  type        = bool
  description = "Enable Cloud Armor security policy"
  default     = true
}

variable "domain_name" {
  type        = string
  description = "Domain name used for the SSL certificate"
  validation {
    condition     = length(trim(var.domain_name)) > 0
    error_message = "domain_name must not be empty"
  }
}
