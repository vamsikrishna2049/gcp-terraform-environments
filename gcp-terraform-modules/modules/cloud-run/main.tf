resource "google_cloud_run_v2_service" "app_service" {
  project  = var.project_id
  location = var.region
  name     = "app-service-${var.environment}"

  template {
    service_account = var.service_account_email

    containers {
      image = var.image_url

      ports {
        container_port = var.container_port
      }

      env {
        name = "DB_PASSWORD"

        value_source {
          secret_key_ref {
            secret  = var.secret_id
            version = "latest"
          }
        }
      }

      resources {
        limits = {
          cpu    = var.cpu
          memory = var.memory
        }
      }
    }

    scaling {
      max_instance_count = var.max_instance_count
    }
  }

  traffic {
    percent = 100
  }
}

resource "google_secret_manager_secret_iam_member" "secret_access" {
  secret_id = var.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${var.service_account_email}"
}
