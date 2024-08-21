provider "google" {
  project = "g-map-flutter-432112"
  region = "asia-northeast1"
}

module "github_provider" {
  source = "./modules/gcp_oidc_provider_github" 
}

module "service_account_deploy_github_oidc" {
  source = "./modules/service_account_deploy_github_oidc" 

  github_repository = "ta9ma0k/flutter_cicd"
  workload_identity_pool_name = module.github_provider.workload_identity_pool_name
}

data "google_client_config" "this" {}

resource "google_project_iam_member" "app_distribution_role" {
  project = data.google_client_config.this.project
  role    = "roles/firebaseappdistro.admin"
  member  = "serviceAccount:${module.service_account_deploy_github_oidc.service_account_id}"
}

output "deploy_account" {
  value = module.service_account_deploy_github_oidc.service_account_id 
}
output "github_provider" {
  value = module.github_provider.workload_identity_provider_name 
}
