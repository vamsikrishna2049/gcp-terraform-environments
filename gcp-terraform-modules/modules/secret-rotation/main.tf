resource "google_service_account" "rotation_sa" {
  account_id   = "rotation-sa-${var.environment}"
  display_name = "Secret rotation service account for ${var.environment}"
  project      = var.project_id
}

resource "google_pubsub_topic" "rotation_topic" {
  name    = "rotation-topic-${var.environment}"
  project = var.project_id
}

resource "google_cloud_run_v2_service" "rotation_svc" {
  name     = "rotation-service-${var.environment}"
  project  = var.project_id
  location = var.region

  template {
    service_account = google_service_account.rotation_sa.email

    containers {
      image = var.rotation_service_image
      ports {
        container_port = 8080
      }
      env {
        name  = "CLOUD_SQL_INSTANCE"
        value = var.cloud_sql_instance_name
      }
      env {
        name  = "SECRET_ID"
        value = var.secret_id
      }
    }
  }

  ingress = "INGRESS_TRAFFIC_INTERNAL_ONLY"
}

resource "google_eventarc_trigger" "rotation_trig" {
  name     = "rotation-trigger-${var.environment}"
  project  = var.project_id
  location = var.region

  matching_criteria {
    attribute = "type"
    value     = "google.cloud.pubsub.topic.v1.messagePublished"
  }

  transport {
    pubsub {
      topic = google_pubsub_topic.rotation_topic.id
    }
  }

  destination {
    cloud_run_service {
      service = google_cloud_run_v2_service.rotation_svc.name
      region  = var.region
    }
  }
}

resource "google_cloud_scheduler_job" "rotation_job" {
  name     = "rotation-job-${var.environment}"
  project  = var.project_id
  region   = var.region
  schedule = var.rotation_schedule

  pubsub_target {
    topic_name = google_pubsub_topic.rotation_topic.id
    data       = base64encode("{\"action\":\"rotate-secret\"}")
  }
}
