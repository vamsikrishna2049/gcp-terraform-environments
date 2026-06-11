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

variable "cidr_block" {
  type        = string
  description = "VPC CIDR block"
  validation {
    condition     = can(regex("^([0-9]{1,3}\.){3}[0-9]{1,3}/16$", var.cidr_block))
    error_message = "cidr_block must be a valid /16 CIDR"
  }
}

variable "public_cidr" {
  type        = string
  description = "Public subnet CIDR block"
  validation {
    condition     = can(regex("^([0-9]{1,3}\.){3}[0-9]{1,3}/24$", var.public_cidr))
    error_message = "public_cidr must be a valid /24 CIDR"
  }
}

variable "private_cidr" {
  type        = string
  description = "Private subnet CIDR block"
  validation {
    condition     = can(regex("^([0-9]{1,3}\.){3}[0-9]{1,3}/24$", var.private_cidr))
    error_message = "private_cidr must be a valid /24 CIDR"
  }
}

variable "data_cidr" {
  type        = string
  description = "Data subnet CIDR block"
  validation {
    condition     = can(regex("^([0-9]{1,3}\.){3}[0-9]{1,3}/24$", var.data_cidr))
    error_message = "data_cidr must be a valid /24 CIDR"
  }
}
