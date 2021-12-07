output "service_endpoint" {
  value = google_cloud_run_service.postgrest.status[0].url
}
