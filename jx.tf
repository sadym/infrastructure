resource "google_storage_bucket" "lts-bucket" {
  name     = "${google_container_cluster.dev_cluster.name}-lts"
  location = "US"
}

resource "kubernetes_namespace" "jx-namespace" {
  metadata {
    name = "jx"
    labels = {
        "env"  = "dev"
        "team" = "jx"
    }
  }
}

resource "kubernetes_secret" "kaniko-secret" {
  metadata {
    name      = "kaniko-secret"
    namespace = "jx"
  }

  data = {
    "kaniko-secret" = base64decode(google_service_account_key.kaniko-sa-key.private_key)
  }
}

resource "kubernetes_secret" "vault-secret" {
  metadata {
    name      = "vault-secret"
    namespace = "jx"
  }
  data = {
    "credentials.json" = base64decode(google_service_account_key.vault-sa-key.private_key)
  }
}

resource "kubernetes_secret" "external-dns-gcp-sa" {
  metadata {
    name      = "external-dns-gcp-sa"
    namespace = "jx"
  }
  data = {
    "credentials.json" = base64decode(google_service_account_key.external-dns-gcp-sa-key.private_key)
  }
}