module "network" {
  source = "git::https://github.com/vamsikrishna2049/gcp-terraform-modules.git//modules/network?ref=4c3b166486612030501f3b79049db5c3fbdcec7d"

  project_id   = var.project_id
  region       = var.region
  environment  = var.environment
  cidr_block   = var.cidr_block
  public_cidr  = var.public_cidr
  private_cidr = var.private_cidr
  data_cidr    = var.data_cidr
}

module "compute_vm" {
  source = "git::https://github.com/vamsikrishna2049/gcp-terraform-modules.git//modules/compute-vm?ref=4c3b166486612030501f3b79049db5c3fbdcec7d"

  depends_on = [module.network]

  project_id       = var.project_id
  zone             = var.zone
  environment      = var.environment
  vpc_id           = module.network.vpc_id
  subnet_id        = module.network.private_subnet_id
  machine_type     = var.web_machine_type
  vm_count         = var.web_vm_count
  vm_names         = var.web_vm_names
  assign_public_ip = false
}

module "cloud_sql" {
  source = "git::https://github.com/vamsikrishna2049/gcp-terraform-modules.git//modules/cloud-sql-postgres?ref=4c3b166486612030501f3b79049db5c3fbdcec7d"

  depends_on = [module.network]

  project_id               = var.project_id
  region                   = var.region
  environment              = var.environment
  instance_name            = "${var.environment}-postgres"
  db_password_secret_id    = var.db_password_secret_id
  private_vpc_connector_id = module.network.vpc_id
  availability_type        = "REGIONAL"
  backup_configuration = {
    enabled                        = true
    start_time                     = "03:00"
    point_in_time_recovery_enabled = true
    transaction_log_retention_days = 14
    backup_retention_settings = {
      retained_backups = 14
      retention_unit   = "COUNT"
    }
  }
}
