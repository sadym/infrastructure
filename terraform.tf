terraform {
  required_version = ">= 0.12.0"
  backend "gcs" {
    bucket      = "cloud-native-entrepreneur-tf-state"
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

provider "google" {
  version = "~> 3.11"
  credentials = file(var.gcp_credentials)
  project     = var.gcp_project
  region      = var.gcp_region
  zone        = var.gcp_zone
}
