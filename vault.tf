resource "google_service_account" "vault-sa" {
  account_id   = "vault-dev"
  display_name = "Vault service account for ${google_container_cluster.dev_cluster.name}"
}

resource "google_service_account_key" "vault-sa-key" {
  service_account_id = google_service_account.vault-sa.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}

resource "google_project_iam_member" "vault-sa-storage-object-admin-binding" {
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.vault-sa.email}"
}

resource "google_project_iam_member" "vault-sa-cloudkms-admin-binding" {
  role   = "roles/cloudkms.admin"
  member = "serviceAccount:${google_service_account.vault-sa.email}"
}

resource "google_project_iam_member" "vault-sa-cloudkms-crypto-binding" {
  role   = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member = "serviceAccount:${google_service_account.vault-sa.email}"
}

resource "google_storage_bucket" "vault-bucket" {
  name     = "${google_container_cluster.dev_cluster.name}-vault"
  location = "US"
  # don't destroy buckets containing vault secrets if re-creating the cluster
  lifecycle {
    prevent_destroy = true
  }
}

resource "google_kms_key_ring" "vault-keyring" {
  name     = "${google_container_cluster.dev_cluster.name}-keyring"
  location = var.gcp_region
}

resource "google_kms_crypto_key" "vault-crypto-key" {
  name            = "${google_container_cluster.dev_cluster.name}-crypto-key"
  key_ring        = google_kms_key_ring.vault-keyring.self_link
  rotation_period = "100000s"
}