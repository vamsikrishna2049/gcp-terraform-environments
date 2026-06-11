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

variable "secret_configs" {
  type = map(object({
    secret_data = string
    labels      = map(string)
  }))
  description = "Secret Manager secret definitions"
  validation {
    condition     = length(var.secret_configs) > 0
    error_message = "secret_configs must contain at least one secret definition"
  }
}
