resource "kubernetes_namespace" "olm-namespace" {
  depends_on = [google_container_node_pool.primary_preemptible_nodes]
  metadata {
    name = "olm"
  }

  provisioner "local-exec" {
    command = "curl -L https://github.com/operator-framework/operator-lifecycle-manager/releases/download/0.14.1/install.sh -o .install-olm.sh && chmod +x .install-olm.sh && ./.install-olm.sh 0.14.1"
  }
}
