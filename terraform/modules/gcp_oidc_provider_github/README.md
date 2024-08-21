# gcp_oidc_provider_github_actions

## 用途

GCP 上に、 github actions の open id connect privider(Workload Identity) を作成する。<br>
https://cloud.google.com/blog/ja/products/identity-security/enabling-keyless-authentication-from-github-actions

## サンプル

```
module "github_provider" {
  source = "./modules/gcp_oidc_provider_github" 
}

module "service_account_deploy_github_oidc" {
  source = "./modules/service_account_deploy_github_oidc" 

  github_repository = "kayac/cl-infrastructure"
  workload_identity_pool_name = module.github_provider.workload_identity_pool_name
}
```
