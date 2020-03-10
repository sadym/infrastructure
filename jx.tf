resource "kubernetes_namespace" "jx-namespace" {
  metadata {
    name = "jx"
  }
}

resource "kubernetes_secret" "kaniko-secret" {
  metadata {
    name      = "kaniko-secret"
    namespace = "jx"
  }

  data = {
    "credentials.json" = base64decode(google_service_account_key.kaniko-sa-key.private_key)
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
