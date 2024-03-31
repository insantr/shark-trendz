# #############################################
# #               Enable API's                #
# #############################################
# Enable IAM API
resource "google_project_service" "iam" {
  service            = "iam.googleapis.com"
  disable_on_destroy = false
}

# Enable Artifact Registry API
resource "google_project_service" "artifactregistry" {
  service            = "artifactregistry.googleapis.com"
  disable_on_destroy = false
}

# Enable Cloud Run API
resource "google_project_service" "cloudrun" {
  service            = "run.googleapis.com"
  disable_on_destroy = false
}

# Enable Cloud Resource Manager API
resource "google_project_service" "resourcemanager" {
  service            = "cloudresourcemanager.googleapis.com"
  disable_on_destroy = false
}

# Enable VCP Access API
resource "google_project_service" "vpcaccess" {
  service            = "vpcaccess.googleapis.com"
  disable_on_destroy = false
}

# Enable Secret Manager API
resource "google_project_service" "secretmanager" {
  service            = "secretmanager.googleapis.com"
  disable_on_destroy = false
}

# Enable Cloud SQL Admin API
resource "google_project_service" "sqladmin" {
  service            = "sqladmin.googleapis.com"
  disable_on_destroy = false
}

# Enable Cloud Filestore API
resource "google_project_service" "file" {
  service            = "file.googleapis.com"
  disable_on_destroy = false
}

# Enable Compute Engine API
resource "google_project_service" "compute" {
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}


# Create the Cloud Run service
resource "google_cloud_run_service" "run_service" {
  name     = var.app_name # The name of the Cloud Run service, derived from a variable.
  location = var.region   # The GCP region where the service will be deployed.

  template {
    spec {
      containers {
        image   = local.docker_image                                          # The Docker image to run in the container.
        command = ["mage", "start", "shark_trendz"] # Command to start the application.
        ports {
          container_port = 6789 # The port that the container listens on.
        }
        resources {
          limits = {
            cpu    = var.container_cpu    # CPU limit for the container.
            memory = var.container_memory # Memory limit for the container.
          }
        }
        # Environment variables for the container to configure application behavior.
        env {
          name  = "FILESTORE_IP_ADDRESS"
          value = module.nfs.internal_ip
        }
        env {
          name  = "FILE_SHARE_NAME"
          value = "share/mage"
        }
        env {
          name  = "GCP_PROJECT_ID"
          value = var.project
        }
        env {
          name  = "GCS_BUCKET"
          value = var.gcs_bucket_name
        }
        env {
          name  = "GCP_REGION"
          value = var.region
        }
        env {
          name  = "GCP_SERVICE_NAME"
          value = var.app_name
        }
        env {
          name  = "BQ_DATASET_NAME"
          value = var.bigquery_dataset_name
        }
        env {
          name  = "BQ_TABLE_NAME"
          value = var.bigquery_table_name
        }
        env {
          name  = "MAGE_DATABASE_CONNECTION_URL"
          value = "postgresql://${var.database_user}:${var.database_password}@/${var.app_name}-db?host=/cloudsql/${google_sql_database_instance.instance.connection_name}"
        }
        env {
          name  = "ULIMIT_NO_FILE"
          value = 16384
        }

        # Mounts a volume for secrets, allowing secure access to sensitive information.
        volume_mounts {
          mount_path = "/home/secrets"
          name       = "secret-volume"
        }
      }

      # Configuration of the volume where secrets are stored.
      volumes {
        name = "secret-volume"
        secret {
          secret_name = google_secret_manager_secret.service-account-key.secret_id
          items {
            key  = "latest"
            path = "gcp_credentials.json"
          }
        }
      }
      service_account_name = google_service_account.my_service.email
    }

    metadata {
      # Annotations to customize and configure the Cloud Run service's behavior.
      annotations = {
        "autoscaling.knative.dev/minScale"         = "1"                                                   # Ensures at least one instance is always running.
        "run.googleapis.com/cloudsql-instances"    = google_sql_database_instance.instance.connection_name # Configures Cloud SQL connection.
        "run.googleapis.com/cpu-throttling"        = "false"                                               # Disables CPU throttling.
        "run.googleapis.com/execution-environment" = "gen2"                                                # Uses the second generation execution environment.
        "run.googleapis.com/vpc-access-connector"  = google_vpc_access_connector.connector.id              # Configures VPC access for the service.
        "run.googleapis.com/vpc-access-egress"     = "private-ranges-only"                                 # Limits egress to private IP ranges.
      }
    }
  }

  # Configuration for routing traffic to the service.
  traffic {
    percent         = 100  # Sends 100% of traffic to the latest revision.
    latest_revision = true # Indicates that traffic should always go to the latest revision.
  }

  metadata {
    # Additional annotations to control service behavior and access.
    annotations = {
      "run.googleapis.com/launch-stage" = "BETA" # Marks the service as being in the BETA launch stage.
      "run.googleapis.com/ingress"      = "all"  # Allows requests from all sources.
    }
  }

  autogenerate_revision_name = true

  # Ensures that dependencies, such as enabling the Cloud Run API and creating a secret version, are resolved before creating this service.
  depends_on = [google_project_service.cloudrun,
  google_secret_manager_secret_version.service-account-key-version]
}

# Allow unauthenticated users to invoke the service
resource "google_cloud_run_service_iam_member" "run_all_users" {
  service  = google_cloud_run_service.run_service.name
  location = google_cloud_run_service.run_service.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

# Display the service IP
output "service_ip" {
  value = module.lb-http.external_ip
}

# ----------------------------------------------------------------------------------------
# Create the Cloud Run DBT Docs service and corresponding resources, uncomment if needed

# resource "google_cloud_run_service" "dbt_docs_service" {
#   name = "${var.app_name}-docs"
#   location = var.region

#   template {
#     spec {
#       containers {
#         image = var.docker_image
#         ports {
#           container_port = 7789
#         }
#         resources {
#           limits = {
#             cpu     = var.container_cpu
#             memory  = var.container_memory
#           }
#         }
#         env {
#           name  = "FILESTORE_IP_ADDRESS"
#           value = google_filestore_instance.instance.networks[0].ip_addresses[0]
#         }
#         env {
#           name  = "FILE_SHARE_NAME"
#           value = "share1"
#         }
#         env {
#           name  = "DBT_DOCS_INSTANCE"
#           value = "1"
#         }
#       }
#     }

#     metadata {
#       annotations = {
#         "autoscaling.knative.dev/minScale"         = "1"
#         "run.googleapis.com/execution-environment" = "gen2"
#         "run.googleapis.com/vpc-access-connector"  = google_vpc_access_connector.connector.id
#         "run.googleapis.com/vpc-access-egress"     = "private-ranges-only"
#       }
#     }
#   }

#   traffic {
#     percent         = 100
#     latest_revision = true
#   }

#   metadata {
#     annotations = {
#       "run.googleapis.com/launch-stage" = "BETA"
#       "run.googleapis.com/ingress"      = "internal-and-cloud-load-balancing"
#     }
#   }

#   autogenerate_revision_name = true

#   # Waits for the Cloud Run API to be enabled
#   depends_on = [google_project_service.cloudrun]
# }

# resource "google_cloud_run_service_iam_member" "run_all_users_docs" {
#   service  = google_cloud_run_service.dbt_docs_service.name
#   location = google_cloud_run_service.dbt_docs_service.location
#   role     = "roles/run.invoker"
#   member   = "allUsers"
# }

# output "docs_service_ip" {
#   value = google_compute_global_address.docs_ip.address
# }
