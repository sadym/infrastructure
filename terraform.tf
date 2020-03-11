terraform {
  required_version = ">= 0.12.0"
  backend "gcs" {
    bucket      = "cldntventr-tf-state"
    prefix      = "dev"
  }
}

variable "gcp_credentials" {
  description = "Path to the GCP service account key"
}

variable "gcp_project" {
  description = "The GCP Project ID"
}

variable "gcp_region" {
  description = "The GCP Region"
}

variable "gcp_zone" {
  description = "The GCP Zone"
}

provider "google" {
  version = "~> 3.11"
  credentials = file(var.gcp_credentials)
  project     = var.gcp_project
  region      = var.gcp_region
  zone        = var.gcp_zone
}

provider "kubernetes" {
  host = "https://${google_container_cluster.dev_cluster.endpoint}"
  username = google_container_cluster.dev_cluster.master_auth.0.username
  password = google_container_cluster.dev_cluster.master_auth.0.password
  client_certificate = base64decode(google_container_cluster.dev_cluster.master_auth.0.client_certificate)
  client_key = base64decode(google_container_cluster.dev_cluster.master_auth.0.client_key)
  cluster_ca_certificate = base64decode(google_container_cluster.dev_cluster.master_auth.0.cluster_ca_certificate)
}
