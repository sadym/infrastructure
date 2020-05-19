resource "google_sql_database_instance" "postgresql-staging" {
  name             = "postgresql-staging"
  database_version = "POSTGRES_11"
  region           = var.gcp_region 

  settings {
    # Second-generation instance tiers are based on the machine
    # type. See argument reference below.
    # https://cloud.google.com/sql/pricing#pg-pricing
    tier = "db-f1-micro"
  }
}