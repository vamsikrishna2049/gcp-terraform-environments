terraform {
  required_version = ">= 1.9.8, < 2.0"
}

provider "google" {
  project = var.project_id
  region  = var.region
}

module "network" {
  source      = "../../modules/network"
  project_id  = var.project_id
  region      = var.region
  environment = var.environment
  cidr_block  = var.cidr_block
  public_cidr = var.public_cidr
  private_cidr = var.private_cidr
  data_cidr   = var.data_cidr
}

output "vpc_id" {
  value = module.network.vpc_id
}
