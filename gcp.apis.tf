resource "google_project_service" "cloudresourcemanager-api" {
  project            = var.gcp_project
  service            = "cloudresourcemanager.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "kubernetes-api" {
  project            = var.gcp_project
  service            = "container.googleapis.com"
  disable_on_destroy = false
  depends_on = [google_project_service.cloudresourcemanager-api]
}

resource "google_project_service" "compute-api" {
  project            = var.gcp_project
  service            = "compute.googleapis.com"
  disable_on_destroy = false
  depends_on = [google_project_service.cloudresourcemanager-api]
}

resource "google_project_service" "iam-api" {
  project            = var.gcp_project
  service            = "iam.googleapis.com"
  disable_on_destroy = false
  depends_on = [google_project_service.cloudresourcemanager-api]
}

resource "google_project_service" "cloudbuild-api" {
  project            = var.gcp_project
  service            = "cloudbuild.googleapis.com"
  disable_on_destroy = false
  depends_on = [google_project_service.cloudresourcemanager-api]
}

resource "google_project_service" "containerregistry-api" {
  project            = var.gcp_project
  service            = "containerregistry.googleapis.com"
  disable_on_destroy = false
  depends_on = [google_project_service.cloudresourcemanager-api]
}

resource "google_project_service" "containeranalysis-api" {
  project            = var.gcp_project
  service            = "containeranalysis.googleapis.com"
  disable_on_destroy = false
  depends_on = [google_project_service.cloudresourcemanager-api]
}

resource "google_project_service" "cloudkms-api" {
  project            = var.gcp_project
  service            = "cloudkms.googleapis.com"
  disable_on_destroy = false
  depends_on = [google_project_service.cloudresourcemanager-api]
}

resource "google_project_service" "clouddns-api" {
  project            = var.gcp_project
  service            = "dns.googleapis.com"
  disable_on_destroy = false
  depends_on = [google_project_service.cloudresourcemanager-api]
}