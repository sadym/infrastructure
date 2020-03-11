resource "google_service_account" "kaniko-sa" {
  account_id   = "${google_container_cluster.dev_cluster.name}-ko"
  display_name = "Kaniko service account for ${google_container_cluster.dev_cluster.name}"
}

resource "google_service_account_key" "kaniko-sa-key" {
  service_account_id = google_service_account.kaniko-sa.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}

resource "google_project_iam_member" "kaniko-sa-storage-admin-binding" {
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.kaniko-sa.email}"
}

resource "google_project_iam_member" "kaniko-sa-storage-object-admin-binding" {
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.kaniko-sa.email}"
}

resource "google_project_iam_member" "kaniko-sa-storage-object-creator-binding" {
  role   = "roles/storage.objectCreator"
  member = "serviceAccount:${google_service_account.kaniko-sa.email}"
}