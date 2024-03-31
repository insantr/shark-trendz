# The section below is commented out. It configures a Google Filestore instance, a managed file storage service.
# To use it, uncomment this section and adjust as necessary based on your requirements.
# resource "google_filestore_instance" "instance" {
#   name = "${var.app_name}"                  # Sets the instance name using a variable for the app name.
#   location = var.zone                       # Specifies the zone where the instance will be created.
#   tier = "BASIC_HDD"                        # Selects the storage tier; in this case, basic HDD.
#
#   file_shares {                             # Configures the file share with a name and capacity.
#     capacity_gb = 1024                      # Sets the file share capacity to 1024 GB.
#     name        = "share1"                  # Names the file share "share1".
#   }
#
#   networks {                                # Specifies network settings for the Filestore instance.
#     network = "default"                     # Uses the default VPC network.
#     modes   = ["MODE_IPV4"]                 # Operates in IPv4 mode.
#   }
# }

# Configures a VPC Access Connector, used for serverless VPC access.
resource "google_vpc_access_connector" "connector" {
  name          = "${var.app_name}-connector" # Names the connector, incorporating the app name for uniqueness.
  ip_cidr_range = "10.8.0.0/28"               # Defines the IP range managed by the connector.
  region        = var.region                  # Specifies the region for the connector.
  network       = "default"                   # Attaches the connector to the default network.
}

# Instructions for using a more cost-effective NFS solution on GCP Compute Engine instead of Google Filestore.
# 1. Uncomment the "nfs" module below to enable it.
# 2. In the `google_cloud_run_service.run_service` resource, update the environment variables to use NFS.
#    - Set "FILESTORE_IP_ADDRESS" to the internal IP of the NFS server (module.nfs.internal_ip).
#    - Set "FILE_SHARE_NAME" to the NFS share path, e.g., "share/mage".
# 3. Ensure the `google_filestore_instance.instance` resource above is commented out or removed.

# Configures an NFS server using a community module from the Terraform Registry.
module "nfs" {
  source  = "DeimosCloud/nfs/google" # Specifies the source of the NFS module.
  version = "1.0.1"                  # The version of the NFS module to use.

  name_prefix          = "${var.app_name}-nfs"          # Sets a prefix for resource names, incorporating the app name.
  attach_public_ip     = true                           # Assigns a public IP to the NFS server for external access.
  project              = var.project                    # The GCP project ID where resources will be provisioned.
  network              = "default"                      # Specifies the VPC network for the NFS server.
  machine_type         = "e2-small"                     # Selects the machine type for the Compute Engine instance running NFS.
  source_image_project = "debian-cloud"                 # The project hosting the source image for the server.
  image_family         = "debian-11-bullseye-v20230629" # The specific Debian image to use.
  export_paths = [                                      # Defines the paths to be shared by the NFS server.
    "/share/mage",
  ]
  capacity_gb = "50" # Sets the disk capacity for the NFS server in GB.
}
