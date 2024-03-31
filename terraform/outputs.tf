output "service_url" {
  value       = "${google_cloud_run_service.run_service.status[0].url}/pipelines"
  description = "The URL on which the deployed service is available"
}