resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }

  lifecycle {
    ignore_changes = [metadata[0].labels, metadata[0].annotations]
  }
}

resource "kubernetes_secret" "alertmanager" {
  depends_on = [kubernetes_namespace.monitoring]
  metadata {
    name = "alertmanager"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }

  data = {
    "alertmanager.yaml" = file("./secrets/alertmanager.yaml")
  }
}
