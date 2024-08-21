# Flutter CICD

[GitHub ActionsでApp Distributionにアプリをアップロードした](https://zenn.dev/shima999ba/articles/ae1fc477744e2a)
[GitHub Actions で Android 向けに自動デプロイする](https://zenn.dev/pressedkonbu/articles/github-actions-for-android)

## 共通作業

### Firebase App Distribution APIを有効化する

Webコンソールから操作

### デプロイ用のサービスアカウントを作成する

```
terraform apply
```

### Firebase AppDistributionを作成する

Webコンソールから操作

### Android

#### AppDistributionにAndroidアプリを登録する

`android/app/build.bradle` のアプリケーションIDで登録する。
※ com.example.xxx は使えない

TODO: `android/local.properties` からversion name, version codeを参照してしまってる。

#### GithubActionsのワークフローを作成する

`.github/workflows/build_androoid.yml`

##### シークレット変数を登録する

ANDROID_KEY_JKS: `base64 -i android/release.jks` で出力される値
ANDROID_STORE_PASSWORD: 署名鍵を作成するときに入力したパスワード
ANDROID_ALIAS_PASSWORD: 署名鍵を作成するときに入力したパスワード
ANDROID_KEY_ALIAS: 署名鍵を作成するときに入力したエイリアス
ANDROID_APP_ID: Firebase > 設定 > マイアプリ > 対象のAndroidアプリのアプリIDの値
