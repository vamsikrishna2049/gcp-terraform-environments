locals {
  api_services = toset([
    "artifactregistry.googleapis.com",
    "cloudbuild.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com",
    "secretmanager.googleapis.com",
    "servicenetworking.googleapis.com",
    "serviceusage.googleapis.com",
    "sqladmin.googleapis.com",
    "storage.googleapis.com",
  ])

  cloud_build_service_account_email = var.cloud_build_service_account_email != "" ? var.cloud_build_service_account_email : "${data.google_project.current.number}@cloudbuild.gserviceaccount.com"

  terraform_sa_role_bindings = {
    for pair in setproduct(var.environments, var.terraform_service_account_roles) :
    "${pair[0]}-${replace(pair[1], "/", "-")}" => {
      environment = pair[0]
      role        = pair[1]
    }
  }
}
