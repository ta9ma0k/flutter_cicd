output "workload_identity_pool_name" {
  value = google_iam_workload_identity_pool.main.name 
}
output "workload_identity_provider_name" {
  value = google_iam_workload_identity_pool_provider.github_provider.name
}
