locals {
  base_name                = "${var.environment}-network"
  vpc_name                 = "${var.environment}-vpc"
  public_subnet_name       = "${var.environment}-public-subnet"
  private_subnet_name      = "${var.environment}-private-subnet"
  data_subnet_name         = "${var.environment}-data-subnet"
  nat_router_name          = "${var.environment}-nat-router"
  nat_gateway_name         = "${var.environment}-nat-gateway"
  allow_internal_name      = "${var.environment}-allow-internal"
  allow_health_checks_name = "${var.environment}-allow-health-checks"
  allow_ssh_iap_name       = "${var.environment}-allow-ssh-iap"
  allow_db_internal_name   = "${var.environment}-allow-db-internal"
}
