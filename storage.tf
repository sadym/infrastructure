resource "kubernetes_storage_class" "ssd-storageclass" {
  metadata {
    name = "ssd"
  }
  storage_provisioner = "kubernetes.io/gce-pd"
  parameters = {
    type = "pd-ssd"
  }
}

resource "kubernetes_storage_class" "ssd-retain-storageclass" {
  metadata {
    name = "ssd-retain"
  }
  storage_provisioner = "kubernetes.io/gce-pd"
  parameters = {
    type = "pd-ssd"
  }
  reclaim_policy      = "Retain"
}

# resource "kubernetes_storage_class" "regional-standard-storageclass" {
#   metadata {
#     name = "regional-standard"
#   }
#   storage_provisioner = "kubernetes.io/gce-pd"
#   parameters = {
#     type = "pd-standard"
#     replication-type = "regional-pd"
#     zones = "${var.gcp_location}-b, ${var.gcp_location}-f"
#   }
# }

# resource "kubernetes_storage_class" "regional-ssd-storageclass" {
#   metadata {
#     name = "regional-ssd"
#   }
#   storage_provisioner = "kubernetes.io/gce-pd"
#   parameters = {
#     type = "pd-ssd"
#     replication-type = "regional-pd"
#     zones = "${var.gcp_location}-b, ${var.gcp_location}-f"
#   }
# }
