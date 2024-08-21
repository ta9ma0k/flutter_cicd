data "google_client_config" "this" {}

resource "google_iam_workload_identity_pool" "main" {
  project = data.google_client_config.this.project
  workload_identity_pool_id = "${data.google_client_config.this.project}-pool"
  description = "For OpenID Connect"
  display_name = "${data.google_client_config.this.project}-pool"
}

resource "google_iam_workload_identity_pool_provider" "github_provider" {
  project = data.google_client_config.this.project
  workload_identity_pool_id = google_iam_workload_identity_pool.main.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-provider"
  display_name = "Github Identity Provider"
  disabled = false
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
    allowed_audiences = []
  }
  attribute_mapping = {
    "google.subject"       = "assertion.sub",
    "attribute.actor"      = "assertion.actor",
    "attribute.repository" = "assertion.repository",
  }
}
