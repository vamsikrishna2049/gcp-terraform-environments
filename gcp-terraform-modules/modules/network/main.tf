// Network module: VPC, subnets, firewall rules, and Cloud NAT

resource "google_compute_network" "vpc" {
  name                    = local.vpc_name
  project                 = var.project_id
  auto_create_subnetworks = false
  description             = "Custom VPC for ${var.environment} environment"
}

resource "google_compute_subnetwork" "public_subnet" {
  name          = local.public_subnet_name
  project       = var.project_id
  region        = var.region
  network       = google_compute_network.vpc.id
  ip_cidr_range = var.public_cidr
  description   = "Public subnet for ${var.environment} workloads"
}

resource "google_compute_subnetwork" "private_subnet" {
  name          = local.private_subnet_name
  project       = var.project_id
  region        = var.region
  network       = google_compute_network.vpc.id
  ip_cidr_range = var.private_cidr
  description   = "Private subnet for internal workloads"
}

resource "google_compute_subnetwork" "data_subnet" {
  name          = local.data_subnet_name
  project       = var.project_id
  region        = var.region
  network       = google_compute_network.vpc.id
  ip_cidr_range = var.data_cidr
  description   = "Data subnet for database and analytics"
}

resource "google_compute_router" "nat_router" {
  name    = local.nat_router_name
  project = var.project_id
  region  = var.region
  network = google_compute_network.vpc.id
}

resource "google_compute_router_nat" "nat_gateway" {
  name                               = local.nat_gateway_name
  project                            = var.project_id
  region                             = var.region
  router                             = google_compute_router.nat_router.name
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = google_compute_subnetwork.private_subnet.name
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
  subnetwork {
    name                    = google_compute_subnetwork.data_subnet.name
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}

resource "google_compute_firewall" "allow_internal" {
  name    = local.allow_internal_name
  project = var.project_id
  network = google_compute_network.vpc.id

  direction    = "INGRESS"
  priority     = 1000
  source_ranges = [var.cidr_block]
  allows {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allows {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  target_tags = ["internal-access"]
  description = "Allow internal VPC traffic for all ports"
}

resource "google_compute_firewall" "allow_health_checks" {
  name    = local.allow_health_checks_name
  project = var.project_id
  network = google_compute_network.vpc.id

  direction    = "INGRESS"
  priority     = 1000
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  allows {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
  target_tags = ["health-check"]
  description = "Allow load balancer health checks"
}

resource "google_compute_firewall" "allow_ssh_iap" {
  name    = local.allow_ssh_iap_name
  project = var.project_id
  network = google_compute_network.vpc.id

  direction    = "INGRESS"
  priority     = 1000
  source_ranges = ["35.235.240.0/20"]
  allows {
    protocol = "tcp"
    ports    = ["22"]
  }
  target_tags = ["ssh-iap"]
  description = "Allow SSH access via Cloud IAP"
}

resource "google_compute_firewall" "allow_db_internal" {
  name    = local.allow_db_internal_name
  project = var.project_id
  network = google_compute_network.vpc.id

  direction    = "INGRESS"
  priority     = 1000
  source_ranges = [var.cidr_block]
  allows {
    protocol = "tcp"
    ports    = ["5432"]
  }
  target_tags = ["db-internal"]
  description = "Allow internal database access within VPC"
}
