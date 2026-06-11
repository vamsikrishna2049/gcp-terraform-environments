terraform {
  required_version = ">= 1.9.8, < 2.0"
}

provider "google" {
  project = var.project_id
  region  = var.region
}

variable "project_id" {
  type        = string
  description = "GCP project ID for bootstrap operations"
}

variable "region" {
  type        = string
  default     = "us-central1"
  description = "Default region for bootstrap operations"
}
