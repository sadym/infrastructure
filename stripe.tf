resource "google_storage_bucket" "stripe" {
  name = "cldntventr-stripe-tf-state"

  bucket_policy_only = true

  location = "US"

  # don't destroy buckets containing wale data if re-creating a cluster
  lifecycle {
    prevent_destroy = true
  }
}

resource "google_kms_key_ring" "stripe-prod" {
  depends_on = [google_project_service.cloudkms-api]
  name     = "stripe-prod"
  location = "global"
}

resource "google_kms_crypto_key" "stripe-prod-key" {
  name     = "stripe-prod-key"
  key_ring = google_kms_key_ring.stripe-prod.self_link
}

resource "google_kms_key_ring" "stripe-test" {
  depends_on = [google_project_service.cloudkms-api]
  name     = "stripe-test"
  location = "global"
}

resource "google_kms_crypto_key" "stripe-test-key" {
  name     = "stripe-test-key"
  key_ring = google_kms_key_ring.stripe-test.self_link
}