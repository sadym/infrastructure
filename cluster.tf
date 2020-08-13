resource "google_container_cluster" "dev_cluster" {
    name                     = "${var.gcp_project}-dev"
    description              = "Dev k8s cluster"
    location                 = var.gcp_zone
    initial_node_count       = 3
    remove_default_node_pool = true
    min_master_version       = "1.15"
    logging_service          = "none"
    monitoring_service       = "none"

    maintenance_policy {
        daily_maintenance_window {
            start_time = "03:00"
        }
    }

    lifecycle {
        ignore_changes = [node_pool]
    }

    depends_on = [
        google_project_service.cloudresourcemanager-api,
        google_project_service.kubernetes-api,
        google_project_service.compute-api,
        google_project_service.iam-api,
        google_project_service.cloudbuild-api,
        google_project_service.containerregistry-api,
        google_project_service.containeranalysis-api,
        google_project_service.cloudkms-api,
        google_project_service.clouddns-api
    ]
}

resource "google_container_node_pool" "primary_preemptible_nodes_n1_standard_4" {
    name        = "dev-np-primary-preemptible-n1-standard-4"
    location    = var.gcp_zone
    cluster     = google_container_cluster.dev_cluster.name
    node_count  = 1

    node_config {
        preemptible  = true
        machine_type = "n1-standard-4"
        disk_size_gb = 100

        metadata = {
            disable-legacy-endpoints = "true"
        }

        oauth_scopes = [
            "https://www.googleapis.com/auth/cloud-platform",
            "https://www.googleapis.com/auth/compute",
            "https://www.googleapis.com/auth/devstorage.full_control",
            "https://www.googleapis.com/auth/service.management",
            "https://www.googleapis.com/auth/servicecontrol",
            "https://www.googleapis.com/auth/logging.write",
            "https://www.googleapis.com/auth/monitoring",
        ]
    }

    autoscaling {
        min_node_count = 5
        max_node_count = 10
    }

    management {
        auto_repair  = true
        auto_upgrade = true
    }

    upgrade_settings {
        max_surge       = 1
        max_unavailable = 1
    }

    lifecycle {
        ignore_changes = [node_count]
    }
}