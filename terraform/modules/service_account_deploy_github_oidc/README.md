# service account deploy github oidc

## 用途

github actions で 処理をするときに oidc で認証して、GCP 上のリソースの取り扱いを行うことができる。

## Usage

```terraform
module "github_provider" {
  source = "./modules/gcp_oidc_provider_github" 
}

module "service_account_deploy_github_oidc" {
  source = "./modules/service_account_deploy_github_oidc" 

  github_repository = "kayac/cl-infrastructure"
  workload_identity_pool_name = module.github_provider.workload_identity_pool_name
}

```

### github actions

```yml
permissions:
  id-token: write
  contents: read

jobs:
  job_name:
    runs-on: ubuntu-latest
    steps:
      - uses: google-github-actions/auth@v1
        with:
          service_account: <terraform output で確認したservice account idを記入>
          workload_identity_provider: <terraform output で確認した workload identity provider nameを記入>
```

### 命名について補足

`https://github.com/kayac/cl-infrastructure` について設定をする場合、以下のようになります。

```terraform
github_repository = "kayac/cl-infrastructure"
```
