data "google_client_config" "this" {}

resource "google_service_account" "github_actions_sa" {
  account_id = "github-oidc-deploy"
  display_name = "Deploy Cloudrun Service Account By OIDC(Github)"
}
resource "google_service_account_iam_binding" "workload_identity" {
  service_account_id = google_service_account.github_actions_sa.id
  members =  ["principalSet://iam.googleapis.com/${var.workload_identity_pool_name}/attribute.repository/${var.github_repository}"]
  role = "roles/iam.workloadIdentityUser"
}
resource "google_project_iam_member" "sa_user" {
  project = data.google_client_config.this.project
  role = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.github_actions_sa.email}"
}
