# Defines an output variable named "service_url"
output "service_url" {
  # Concatenates the base URL of the Cloud Run service with "/pipelines" to form the full service URL.
  # The URL is extracted from the first status object of the Cloud Run service resource.
  value = "${google_cloud_run_service.run_service.status[0].url}/pipelines"

  # Provides a description for the output, clarifying its purpose.
  description = "The URL on which the deployed service is available"
}
