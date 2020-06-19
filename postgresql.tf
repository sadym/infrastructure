resource "google_service_account" "psql-wale-sa" {
  account_id   = "${google_container_cluster.dev_cluster.name}-psql-wale"
  display_name = "PSQL WalE service account for the postgresql cluster in ${google_container_cluster.dev_cluster.name}"
}

resource "google_service_account_key" "psql-wale-sa-key" {
  service_account_id = google_service_account.psql-wale-sa.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}

resource "google_storage_bucket" "psql_wale_bucket" {
  name = "${google_container_cluster.dev_cluster.name}-psql-wale"

  bucket_policy_only = true

  location = "US"

  # don't destroy buckets containing wale data if re-creating a cluster
  lifecycle {
    prevent_destroy = true
  }
}

resource "google_storage_bucket_iam_binding" "psql_wale_bucket_iam" {
  bucket = google_storage_bucket.psql_wale_bucket.name
  role   = "roles/storage.objectAdmin"

  members = [
    "serviceAccount:${google_service_account.psql-wale-sa.email}"
  ]
}

resource "kubernetes_secret" "psql-wale-creds" {
  depends_on = [kubernetes_namespace.jx-namespace]

  metadata {
    namespace = "jx"
    name      = "psql-wale-creds"
    labels = {
      "component" = "jx"
    }
    annotations = {
      "replicator.v1.mittwald.de/replication-allowed"            = "true"
      "replicator.v1.mittwald.de/replication-allowed-namespaces" = "jx-*"
    }
  }

  data = {
    "key.json" = base64decode(google_service_account_key.psql-wale-sa-key.private_key)
  }
}