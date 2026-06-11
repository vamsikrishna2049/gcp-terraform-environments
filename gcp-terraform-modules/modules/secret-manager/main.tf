resource "google_secret_manager_secret" "secret" {
  for_each = var.secret_configs

  project   = var.project_id
  secret_id = each.key

  replication {
    automatic = true
  }

  labels = lookup(each.value, "labels", {})
}

resource "google_secret_manager_secret_version" "secret_version" {
  for_each = var.secret_configs

  secret      = google_secret_manager_secret.secret[each.key].id
  secret_data = each.value.secret_data
}
