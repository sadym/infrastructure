resource "kubernetes_priority_class" "production" {
  metadata {
    name = "production"
  }
  value = 1000000
  global_default = false
  description = "This priority class should be used for Production service pods only."
}