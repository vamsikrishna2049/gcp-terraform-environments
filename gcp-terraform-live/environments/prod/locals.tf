locals {
  service_suffix = var.environment
  environment_tags = {
    environment = var.environment
    region      = var.region
  }
}
