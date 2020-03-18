resource "kubernetes_namespace" "monitor-namespace" {
  depends_on = [kubernetes_namespace.olm-namespace]

  metadata {
    name = "monitor"
  }

  provisioner "local-exec" {
    command = <<EOT
        kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.37/example/prometheus-operator-crd/monitoring.coreos.com_alertmanagers.yaml &&
        kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.37/example/prometheus-operator-crd/monitoring.coreos.com_podmonitors.yaml &&
        kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.37/example/prometheus-operator-crd/monitoring.coreos.com_prometheuses.yaml &&
        kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.37/example/prometheus-operator-crd/monitoring.coreos.com_prometheusrules.yaml &&
        kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.37/example/prometheus-operator-crd/monitoring.coreos.com_servicemonitors.yaml &&
        kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.37/example/prometheus-operator-crd/monitoring.coreos.com_thanosrulers.yaml &&
        kubectl create -f https://operatorhub.io/install/prometheus.yaml
    EOT
  }
}

# To delete:
# kubectl delete -f https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.37/example/prometheus-operator-crd/monitoring.coreos.com_alertmanagers.yaml &&
# kubectl delete -f https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.37/example/prometheus-operator-crd/monitoring.coreos.com_podmonitors.yaml &&
# kubectl delete -f https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.37/example/prometheus-operator-crd/monitoring.coreos.com_prometheuses.yaml &&
# kubectl delete -f https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.37/example/prometheus-operator-crd/monitoring.coreos.com_prometheusrules.yaml &&
# kubectl delete -f https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.37/example/prometheus-operator-crd/monitoring.coreos.com_servicemonitors.yaml &&
# kubectl delete -f https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.37/example/prometheus-operator-crd/monitoring.coreos.com_thanosrulers.yaml &&
# kubectl delete -f https://operatorhub.io/install/prometheus.yaml