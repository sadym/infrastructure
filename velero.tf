resource "google_service_account" "velero-sa" {
  account_id   = "${google_container_cluster.dev_cluster.name}-velero"
  display_name = "velero service account for ${google_container_cluster.dev_cluster.name}"
}

resource "google_service_account_key" "velero-sa-key" {
  service_account_id = google_service_account.velero-sa.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}

resource "google_storage_bucket" "backup_bucket" {
  name = "${google_container_cluster.dev_cluster.name}-backup"

  bucket_policy_only = true

  location = "US"

  # don't destroy buckets containing backup data if re-creating a cluster
  lifecycle {
    prevent_destroy = true
  }
}

resource "google_storage_bucket_iam_binding" "velero_bucket_iam" {
  bucket = google_storage_bucket.backup_bucket.name
  role   = "roles/storage.objectAdmin"

  members = [
    "serviceAccount:${google_service_account.velero-sa.email}"
  ]
}

resource "google_project_iam_custom_role" "velero-role" {
  role_id     = "velero.server"
  title       = "Velero server role"
  description = "Velero server role from https://velero.io/docs/v1.0.0/gcp-config/"
  permissions = [
    "compute.disks.get",
    "compute.disks.create",
    "compute.disks.createSnapshot",
    "compute.snapshots.get",
    "compute.snapshots.create",
    "compute.snapshots.useReadOnly",
    "compute.snapshots.delete",
    "compute.zones.get"
  ]
}

resource "google_project_iam_member" "velero-sa-velero-role-binding" {
  role   = "projects/${var.gcp_project}/roles/velero.server"
  member = "serviceAccount:${google_service_account.velero-sa.email}"
}

resource "kubernetes_namespace" "velero" {
  metadata {
    name = "velero"
    labels = {
      "component" = "velero"
    }
  }
}

resource "kubernetes_secret" "velero-secret" {
  depends_on = [kubernetes_namespace.velero]

  metadata {
    namespace = "velero"
    name      = "velero-secret"
    labels = {
      "component" = "velero"
    }
  }

  data = {
    "cloud" = base64decode(google_service_account_key.velero-sa-key.private_key)
  }
}
