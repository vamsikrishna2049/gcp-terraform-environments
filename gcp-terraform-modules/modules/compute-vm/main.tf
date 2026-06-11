locals {
  instance_names = [for idx, name in var.vm_names : name]
}

resource "google_service_account" "vm_sa" {
  count        = var.vm_count
  account_id   = "vm-sa-${var.environment}-${count.index}"
  display_name = "VM service account for ${var.environment} instance ${count.index}"
  project      = var.project_id
}

resource "google_compute_instance" "instances" {
  count        = var.vm_count
  name         = local.instance_names[count.index]
  project      = var.project_id
  zone         = var.zone
  machine_type = var.machine_type

  boot_disk {
    initialize_params {
      image = "ubuntu-2204-lts"
      size  = var.disk_size_gb
    }
  }

  network_interface {
    subnetwork = var.subnet_id
  }

  service_account {
    email  = google_service_account.vm_sa[count.index].email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  metadata = {
    enable-oslogin = "TRUE"
    google-logging-enabled = "true"
  }

  tags = ["internal-access", "ssh-iap"]
}

resource "google_compute_instance_iam_member" "vm_sa_binding" {
  count    = var.vm_count
  project  = var.project_id
  zone     = var.zone
  instance = google_compute_instance.instances[count.index].name
  role     = "roles/compute.instanceAdmin.v1"
  member   = "serviceAccount:${google_service_account.vm_sa[count.index].email}"
}
