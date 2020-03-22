resource "google_kms_key_ring" "sops" {
  depends_on = [google_project_service.cloudkms-api]
  name     = "sops"
  location = "global"
}

resource "google_kms_crypto_key" "sops-key" {
  name     = "sops-key"
  key_ring = google_kms_key_ring.sops.self_link
}