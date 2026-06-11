resource "google_compute_global_address" "static_ip" {
  name    = "lb-ip-${var.environment}"
  project = var.project_id
}

resource "google_compute_managed_ssl_certificate" "ssl_cert" {
  name    = "lb-cert-${var.environment}"
  project = var.project_id

  managed {
    domains = [var.domain_name]
  }
}

resource "google_compute_health_check" "health_check" {
  name    = "lb-health-${var.environment}"
  project = var.project_id

  http_health_check {
    request_path = var.health_check_path
    port         = var.backend_port
  }

  check_interval_sec  = var.health_check_interval
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 3
}

resource "google_compute_instance_group" "instance_group" {
  name      = "lb-instance-group-${var.environment}"
  project   = var.project_id
  zone      = var.zone
  instances = var.vm_instance_ids
}

resource "google_compute_backend_service" "backend_service" {
  name        = "lb-backend-${var.environment}"
  project     = var.project_id
  protocol    = "HTTP"
  port_name   = "http"
  timeout_sec = 10

  backend {
    group = google_compute_instance_group.instance_group.self_link
  }

  health_checks = [google_compute_health_check.health_check.self_link]
  security_policy = var.cloud_armor_enabled ? google_compute_security_policy.cloud_armor[0].id : null

  dynamic "cdn_policy" {
    for_each = var.cdn_enabled ? [1] : []
    content {
      cache_mode = "USE_ORIGIN_HEADERS"
    }
  }
}

resource "google_compute_security_policy" "cloud_armor" {
  count   = var.cloud_armor_enabled ? 1 : 0
  name    = "armor-policy-${var.environment}"
  project = var.project_id

  rule {
    action   = "deny(403)"
    priority = 1000
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["0.0.0.0/0"]
      }
    }
  }
}

resource "google_compute_url_map" "url_map" {
  name    = "lb-url-map-${var.environment}"
  project = var.project_id

  default_service = google_compute_backend_service.backend_service.self_link
}

resource "google_compute_target_https_proxy" "https_proxy" {
  name             = "lb-https-proxy-${var.environment}"
  project          = var.project_id
  url_map          = google_compute_url_map.url_map.self_link
  ssl_certificates = [google_compute_managed_ssl_certificate.ssl_cert.self_link]
}

resource "google_compute_global_forwarding_rule" "https_forwarding" {
  name       = "lb-https-forwarding-${var.environment}"
  project    = var.project_id
  port_range = "443"
  target     = google_compute_target_https_proxy.https_proxy.self_link
  ip_address = google_compute_global_address.static_ip.address
}
