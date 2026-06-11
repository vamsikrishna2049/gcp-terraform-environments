data "google_project" "current" {
  project_id = var.project_id
}

resource "google_project_service" "required" {
  for_each = local.api_services

  project = var.project_id
  service = each.value

  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_storage_bucket" "terraform_state" {
  for_each = var.environments

  project                     = var.project_id
  name                        = "${var.project_id}-terraform-state-${each.key}"
  location                    = var.region
  uniform_bucket_level_access = true
  force_destroy               = var.state_bucket_force_destroy

  versioning {
    enabled = true
  }

  labels = {
    environment = each.key
    purpose     = "terraform-state"
    managed_by  = "terraform"
  }

  depends_on = [google_project_service.required]
}

resource "google_storage_bucket" "cloudbuild_artifacts" {
  project                     = var.project_id
  name                        = "${var.project_id}-cloudbuild-artifacts"
  location                    = var.region
  uniform_bucket_level_access = true
  force_destroy               = var.artifact_bucket_force_destroy

  versioning {
    enabled = true
  }

  labels = {
    purpose    = "cloudbuild-artifacts"
    managed_by = "terraform"
  }

  depends_on = [google_project_service.required]
}

resource "google_service_account" "terraform" {
  for_each = var.environments

  project      = var.project_id
  account_id   = "terraform-${each.key}"
  display_name = "Terraform ${title(each.key)}"
  description  = "Terraform deployment service account for ${each.key}."

  depends_on = [google_project_service.required]
}

resource "google_project_iam_member" "terraform_roles" {
  for_each = local.terraform_sa_role_bindings

  project = var.project_id
  role    = each.value.role
  member  = "serviceAccount:${google_service_account.terraform[each.value.environment].email}"
}

resource "google_service_account_iam_member" "cloudbuild_impersonates_terraform" {
  for_each = var.environments

  service_account_id = google_service_account.terraform[each.key].name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "serviceAccount:${local.cloud_build_service_account_email}"
}

resource "google_secret_manager_secret" "db_password" {
  for_each = var.environments

  project   = var.project_id
  secret_id = "db-password-${each.key}"

  replication {
    auto {}
  }

  labels = {
    environment = each.key
    purpose     = "database-password"
    managed_by  = "terraform"
  }

  depends_on = [google_project_service.required]
}

resource "random_password" "db_password" {
  for_each = var.create_db_password_versions ? var.environments : []

  length           = var.db_password_length
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "google_secret_manager_secret_version" "db_password" {
  for_each = var.create_db_password_versions ? var.environments : []

  secret      = google_secret_manager_secret.db_password[each.key].id
  secret_data = random_password.db_password[each.key].result
}

resource "google_artifact_registry_repository" "docker" {
  project       = var.project_id
  location      = var.region
  repository_id = var.artifact_registry_repository_id
  description   = "Docker images for GCP DevSecOps workloads."
  format        = "DOCKER"

  labels = {
    purpose    = "container-images"
    managed_by = "terraform"
  }

  depends_on = [google_project_service.required]
}

resource "google_artifact_registry_repository_iam_member" "cloudbuild_writer" {
  project    = var.project_id
  location   = google_artifact_registry_repository.docker.location
  repository = google_artifact_registry_repository.docker.name
  role       = "roles/artifactregistry.writer"
  member     = "serviceAccount:${local.cloud_build_service_account_email}"
}
