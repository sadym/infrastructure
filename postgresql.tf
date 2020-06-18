resource "google_service_account" "psql-wale-sa-staging" {
  account_id   = "${google_container_cluster.dev_cluster.name}-psql-wale-s"
  display_name = "PSQL WalE service account for the staging postgresql cluster in ${google_container_cluster.dev_cluster.name}"
}

resource "google_service_account_key" "psql-wale-sa-staging-key" {
  service_account_id = google_service_account.psql-wale-sa-staging.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}

resource "google_storage_bucket" "psql_wale_bucket_staging" {
  name = "${google_container_cluster.dev_cluster.name}-psql-wale-staging"

  bucket_policy_only = true

  location = "US"

  # don't destroy buckets containing wale data if re-creating a cluster
  lifecycle {
    prevent_destroy = true
  }
}

resource "google_storage_bucket_iam_binding" "psql_wale_bucket_staging_iam" {
  bucket = google_storage_bucket.psql_wale_bucket_staging.name
  role   = "roles/storage.objectAdmin"

  members = [
    "serviceAccount:${google_service_account.psql-wale-sa-staging.email}"
  ]
}

resource "kubernetes_secret" "psql-wale-staging-creds" {
  depends_on = [kubernetes_namespace.jx-namespace]

  metadata {
    namespace = "jx"
    name      = "psql-wale-staging-creds"
    labels = {
      "component" = "jx"
    }
    annotations = {
      "replicator.v1.mittwald.de/replication-allowed"            = "true"
      "replicator.v1.mittwald.de/replication-allowed-namespaces" = "jx-*"
    }
  }

  data = {
    "key.json" = base64decode(google_service_account_key.psql-wale-sa-staging-key.private_key)
  }
}

resource "google_service_account" "psql-wale-sa-prod" {
  account_id   = "${google_container_cluster.dev_cluster.name}-psql-wale-p"
  display_name = "PSQL WalE service account for the prod postgresql cluster in ${google_container_cluster.dev_cluster.name}"
}

resource "google_service_account_key" "psql-wale-sa-prod-key" {
  service_account_id = google_service_account.psql-wale-sa-prod.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}

resource "google_storage_bucket" "psql_wale_bucket_prod" {
  name = "${google_container_cluster.dev_cluster.name}-psql-wale-prod"

  bucket_policy_only = true

  location = "US"

  # don't destroy buckets containing wale data if re-creating a cluster
  lifecycle {
    prevent_destroy = true
  }
}

resource "google_storage_bucket_iam_binding" "psql_wale_bucket_prod_iam" {
  bucket = google_storage_bucket.psql_wale_bucket_prod.name
  role   = "roles/storage.objectAdmin"

  members = [
    "serviceAccount:${google_service_account.psql-wale-sa-prod.email}"
  ]
}

resource "kubernetes_secret" "psql-wale-prod-creds" {
  depends_on = [kubernetes_namespace.jx-namespace]

  metadata {
    namespace = "jx"
    name      = "psql-wale-prod-creds"
    labels = {
      "component" = "jx"
    }
    annotations = {
      "replicator.v1.mittwald.de/replication-allowed"            = "true"
      "replicator.v1.mittwald.de/replication-allowed-namespaces" = "jx-*"
    }
  }

  data = {
    "key.json" = base64decode(google_service_account_key.psql-wale-sa-prod-key.private_key)
  }
}