variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "region" {
  type        = string
  description = "GCP region"
}

variable "zone" {
  type        = string
  description = "GCP zone"
}

variable "environment" {
  type        = string
  description = "Environment"
}

variable "cidr_block" {
  type        = string
  description = "VPC CIDR block"
}

variable "public_cidr" {
  type        = string
  description = "Public subnet CIDR"
}

variable "private_cidr" {
  type        = string
  description = "Private subnet CIDR"
}

variable "data_cidr" {
  type        = string
  description = "Data subnet CIDR"
}

variable "vm_names" {
  type        = list(string)
  description = "Names for VM instances"
}

variable "machine_type" {
  type        = string
  description = "Machine type for VM instances"
}

variable "db_instance_name" {
  type        = string
  description = "Cloud SQL instance name"
}

variable "db_password_secret_id" {
  type        = string
  description = "Database password secret identifier"
  sensitive   = true
}

variable "domain_name" {
  type        = string
  description = "Domain name for load balancer SSL"
}

module "network" {
  source      = "../network"
  project_id  = var.project_id
  region      = var.region
  environment = var.environment
  cidr_block  = var.cidr_block
  public_cidr = var.public_cidr
  private_cidr = var.private_cidr
  data_cidr   = var.data_cidr
}

module "compute_vm" {
  source      = "../compute-vm"
  depends_on  = [module.network]
  project_id  = var.project_id
  zone        = var.zone
  environment = var.environment
  vpc_id      = module.network.vpc_id
  subnet_id   = module.network.private_subnet_id
  machine_type = var.machine_type
  vm_count    = length(var.vm_names)
  vm_names    = var.vm_names
  assign_public_ip = false
}

module "cloud_sql" {
  source      = "../cloud-sql-postgres"
  depends_on  = [module.network]
  project_id  = var.project_id
  region      = var.region
  environment = var.environment
  instance_name = var.db_instance_name
  db_password_secret_id = var.db_password_secret_id
  private_vpc_connector_id = module.network.vpc_id
}

module "load_balancer" {
  source      = "../load-balancer"
  depends_on  = [module.compute_vm]
  project_id  = var.project_id
  environment = var.environment
  vm_instance_ids = module.compute_vm.vm_ids
  zone        = var.zone
  domain_name = var.domain_name
}
