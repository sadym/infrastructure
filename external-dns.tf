variable "cluster_dns" {
  description = "The DNS domain name"
}

resource "google_service_account" "external-dns-gcp-sa" {
  account_id   = "external-dns-dev"
  display_name = "External DNS service account for ${google_container_cluster.dev_cluster.name}"
}

resource "google_service_account_key" "external-dns-gcp-sa-key" {
  service_account_id = google_service_account.external-dns-gcp-sa.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}

resource "google_project_iam_member" "external-dns-gcp-sa-dns-admin-binding" {
  role   = "roles/dns.admin"
  member = "serviceAccount:${google_service_account.external-dns-gcp-sa.email}"
}

resource "google_dns_managed_zone" "dns-managed-zone" {
  name        = "dns-managed-zone"
  dns_name    = "${var.cluster_dns}."
  description = "Managed DNS zone"
}
