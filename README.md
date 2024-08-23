# Flutter CICD

[GitHub ActionsでApp Distributionにアプリをアップロードした](https://zenn.dev/shima999ba/articles/ae1fc477744e2a)
[GitHub Actions で Android 向けに自動デプロイする](https://zenn.dev/pressedkonbu/articles/github-actions-for-android)
[GitHub Actions で iOS 向けに自動デプロイする](https://zenn.dev/pressedkonbu/articles/254ca2fc3cd1ab)

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

`.github/workflows/deploy_androoid.yml`

#### シークレット変数を登録する

ANDROID_KEY_JKS: `base64 -i android/release.jks` で出力される値
ANDROID_STORE_PASSWORD: 署名鍵を作成するときに入力したパスワード
ANDROID_ALIAS_PASSWORD: 署名鍵を作成するときに入力したパスワード
ANDROID_KEY_ALIAS: 署名鍵を作成するときに入力したエイリアス
ANDROID_APP_ID: Firebase > 設定 > マイアプリ > 対象のAndroidアプリのアプリIDの値

### IOS

#### AppDistributionにAndroidアプリを登録する

２つ目は 設定 > マイアプリから追加

#### GithubActionsのワークフローを作成する

`.github/workflows/deploy_ios.yml`

#### シークレット変数を登録する


APPSTORE_CERT_BASE64: `base64 -i flutter-cicd.p12` で出力される値
APPSTORE_CERT_PASSWORD: p12証明書を作った時のパスワード(flutter-cicd-0821)
MOBILEPROVISION_ADHOC_BASE64: `base64 -i hoge.mobileprovision` で出力される値
KEYCHAIN_PASSWORD: 一時的なキーチェインパスワード
EXPORT_OPTIONS: あまりよく分かってないけど下記でいけた。

[flutter build ipa でipaファイルが生成されない](https://zenn.dev/tsukatsuka1783/articles/flutter_build_ipa)
```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>ad-hoc</string> <!-- または "ad-hoc", "enterprise", "development" など -->
    <key>teamID</key>
    <string>UKW4292Y6S</string>
    <key>uploadBitcode</key>
    <true/> <!-- Bitcodeを含めるかどうか -->
    <key>uploadSymbols</key>
    <true/> <!-- dSYMファイルを含めるかどうか -->
    <key>compileBitcode</key>
    <true/> <!-- Bitcodeをコンパイルするかどうか -->
    <key>provisioningProfiles</key>
    <dict>
        <key>com.ta9ma0k.fluttercicd</key> <!-- ここにApp IDを記入 -->
        <string>flutter-cicd-appdistributions</string> <!-- プロビジョニングプロファイルの名前 -->
    </dict>
    <key>signingStyle</key>
    <string>manual</string> <!-- "manual" か "automatic" を指定 -->
    <key>thinning</key>
    <string>&lt;none&gt;</string> <!-- アプリスライスの指定、通常は "none" -->
</dict>
</plist>
```

##### IOSの証明書作成手順

[ややこしい証明書周りの関係をざっくり整理して理解してみた](https://zenn.dev/ncdc/articles/apple_delevoler)
[怖くないiOSの証明書](https://qiita.com/bl-lia/items/c6ec88020d526cdb454c)

1. CSRを作成し証明書を取得する。(配信する場合はAdHocを選択？)
   [iOS, Certificate 証明書を作ってみる](https://i-app-tec.com/ios/apply-application.html)
2. p12ファイルを生成する。
   1で取得した証明書をローカルのキーチェインに登録しみp12ファイルを書き出す。
   キーチェインがログイン＞自分の証明書になっていること。
   [iOSのp12証明書の作り方](https://faq.growthbeat.com/article/178-ios-p12)
3. AppIDを登録する。
   [iOS App IDs を登録する](https://i-app-tec.com/ios/ios-app-ids.html)
4. Provisioning Fileを取得する。
   [Provisioning Profile を作ってみる](https://i-app-tec.com/ios/provisioning-profile.html)
5. flutterのワークスペースを開き、autometically manage signingをoffにする。Provisioning Profileに4で取得したものを指定する。

